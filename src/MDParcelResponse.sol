// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

contract MdParcelResponse is FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;

    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;
    string private s_lastSearchTerm;

    error UnexpectedRequestID(bytes32 requestId);


    Property[] Properties;
    
    struct Property{
        string searchTerm;
        string valuationLabel;
    }

    event Response(bytes32 indexed requestId, bytes response, bytes err);
    event PropertyAdded(string searchTerm, string valuationLabel);
    event LogEntered(string searchTerm);
    event LogRequestSent(bytes32 indexed requestId, string searchTerm);
    event LogFulfillment(bytes32 indexed requestId, string searchTerm, string valuationLabel);
    event LogError(bytes32 indexed requestId, string error);

    //Sepolia Router address;
    address router = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;

    //Functions Subscription ID
    uint64 subscriptionId = 1824; 

    //Gas limit for callback tx do not change
    uint32 gasLimit = 300000;

    //DoN ID for Sepolia, from supported networks in the docs
    bytes32 donId =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;

    constructor() FunctionsClient(router) ConfirmedOwner(msg.sender) {}

    function sendRequest(string memory addressLookUp) external onlyOwner returns (bytes32 requestId) {

        emit LogEntered(addressLookUp);
        // Source JavaScript to run
        string memory source =
            string.concat("const url = `https://geodata.md.gov/imap/rest/services/PlanningCadastre/MD_PropertyData/MapServer/0/query?where=address='", addressLookUp,"'&outFields=*&outSR=4326&f=json`; const newRequest = Functions.makeHttpRequest({ url }); const newResponse = await newRequest; if (newResponse.error) { throw Error(`Error fetching news`); } return Functions.encodeString(JSON.stringify(newResponse.data.features[0].attributes.NFMTTLVL));");

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source);

        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donId
        );
        s_lastSearchTerm = addressLookUp;
        
        emit LogRequestSent(s_lastRequestId, s_lastSearchTerm);

        return s_lastRequestId;
    }

    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            emit LogError(requestId, "UnexpectedRequestID");
            revert UnexpectedRequestID(requestId);
        }
        Properties.push(Property(s_lastSearchTerm, string(response)));
        emit PropertyAdded(s_lastSearchTerm, string(response));
        s_lastResponse = response;

        emit LogFulfillment(requestId, s_lastSearchTerm, string(response));

        s_lastError = err;
        emit Response(requestId, s_lastResponse, s_lastError);
    }

    // Function to return all results
    function getSearchResult() public view returns (string[] memory) {
        string[] memory allProperties = new string[](Properties.length);
        for (uint i = 0; i < Properties.length; i++) {
            allProperties[i] = string.concat(Properties[i].searchTerm, ": ",Properties[i].valuationLabel);
        }
        return allProperties;
    }
}