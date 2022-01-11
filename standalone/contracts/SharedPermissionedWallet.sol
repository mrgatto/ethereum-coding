// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SharedPermissionedWallet {

    uint public totalFunds;

    address owner;

    mapping(address => bool) members;

    event WithdrawEvent(address to, uint amount);

    modifier isTheOwner() {
        require(owner == msg.sender);
        _;
    }

    constructor() {
        owner = msg.sender;
        members[owner] = true;
    }

    receive() payable external {
        totalFunds += msg.value;
    }

    function addMember(address member) public isTheOwner {
        members[member] = true;
    }

    function removeMember(address member) public isTheOwner {
        members[member] = false;
    }

    function transferOwnership(address newOwner) public isTheOwner {
        members[owner] = false;
        members[newOwner] = true;
        
        owner = newOwner;
    }

    function withdraw(uint amount) public {
        require(members[msg.sender], "Not allowed to withdraw");
        require(totalFunds >= amount, "Insufficient funds");

        totalFunds -= amount;
        emit WithdrawEvent(msg.sender, amount);

        payable(msg.sender).transfer(amount);
    } 

}