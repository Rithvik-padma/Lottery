pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address payable[] public participants;
    address payable admin;
    address payable internal store = payable(0xdD870fA1b7C4700F2BD7f44238821C26f7392148); //address to store the remaining 0.2 ether

    constructor(){
        admin = payable(msg.sender);
    }

    //to check for the received amount
    receive() external payable{
        require(msg.value == 1 ether, "exact 1 Ether is the participation fee");
        require(msg.sender != admin, "Admin cannot participate!");
        participants.push(payable(msg.sender));
    }

    //to create a random number for picking the winner
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    //to pick a winner among the participants
    function Winner() public{
        require(msg.sender == admin, "You are not the admin!");
        require(participants.length >= 2, "Not enough participants are participating in the lottery");
        address payable winner;
        winner = participants[random() % participants.length];
        winner.transfer(1.8 ether);
        store.transfer(0.2 ether);
        participants = new address payable[](0);
    }
}