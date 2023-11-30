 // SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.19;
 
//depreciation -> business owner. Claim car
//write off based on depreciation 
//business owner, not 
//state
//different assets classes future readme
//zillow data maybe?
 contract TaxProfileManager{
    uint public taskCount = 0;
    mapping(uint => UserProfile) public userProfiles;
    
    struct UserProfile{
        uint id;
        string walletAddress;
        bool businessOwner;
        string state;
    }
}