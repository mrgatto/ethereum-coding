// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SharedMultiOwnerPermissionedWallet {

    uint public totalFunds;

    mapping(address => bool) owners;
    mapping(address => bool) members;

    event WithdrawEvent(address to, uint amount);
    event ChangedMemberEvent(address by, address memeber, bool added);
    event ChangedOwnerEvent(address by, address owner, bool added);

    modifier isOwner() {
        require(owners[msg.sender]);
        _;
    }

    modifier isOwnerOrMemeber() {
        require(owners[msg.sender] || members[msg.sender]);
        _;
    }

    constructor() {
        owners[msg.sender] = true;
    }

    receive() payable external {
        totalFunds += msg.value;
    }

    function addMember(address member) public isOwner {
        members[member] = true;
        emit ChangedOwnerEvent(msg.sender, member, true);
    }

    function removeMember(address member) public isOwner {
        members[member] = false;
        emit ChangedOwnerEvent(msg.sender, member, false);
    }

    function addOwner(address newOwner) public isOwner {
        owners[newOwner] = true;
        emit ChangedOwnerEvent(msg.sender, newOwner, true);
    }

    function removeOwner(address owner) public isOwner {
        owners[owner] = false;
        emit ChangedOwnerEvent(msg.sender, owner, false);
    }

    function withdraw(uint amount) public isOwnerOrMemeber {
        require(totalFunds >= amount, "Insufficient funds");

        totalFunds -= amount;
        emit WithdrawEvent(msg.sender, amount);

        payable(msg.sender).transfer(amount);
    } 

}