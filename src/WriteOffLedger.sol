 // SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.19;
 
 contract WriteOffLedger{
    struct WriteOff{
        string tokenizedAssetAddress;
        uint amountWholeDollar;
        uint amountFractional;
    }
    mapping(string => WriteOff[]) public writeOffLedgers;

    function createNewLedger(string memory userAddress, string memory tokenAssetAddress, uint dollarAmount, uint deciamlPlace) public{
        WriteOff memory writeOff = WriteOff(
        {
            tokenizedAssetAddress: tokenAssetAddress,
            amountWholeDollar: dollarAmount,
            amountFractional: deciamlPlace
        });
        writeOffLedgers[userAddress].push(writeOff);
    }

    function getLedgerForAddress(string memory userAddress) public view returns(WriteOff[] memory){
        return writeOffLedgers[userAddress];
    }
}