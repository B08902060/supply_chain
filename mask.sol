pragma solidity ^0.4.17;

contract Mask {
    address private owner;
    address[10] private user;
    uint public userNumber;
    bytes32 private mask;
    constructor()public{
        owner=msg.sender;
        user[0]=owner;
        userNumber=1;
    }
    modifier userOnly(){
        uint i=0;
        for(;i<userNumber;i++){
            if(user[i]==msg.sender){
                break;
            }
        }
        require(i<userNumber);
        _;
    }
    function setAddeess(address newAddress)public userOnly{
        user[userNumber]=newAddress;
        userNumber++;
    }
    function GenerateMask(string text)public userOnly{
        mask=sha256(abi.encodePacked(keccak256(abi.encodePacked(text,owner))));
    }
    function refresh(uint a,bytes32 target)pure private returns(bytes32){
        for(uint i=0;i<a;i++){
            target=sha256(abi.encodePacked(target));
        }
        return target;
    }
    function refreshMask(address sender,uint time)public userOnly{
        bytes32 newone=sha256(abi.encodePacked(sender));
        mask=refresh(time,(mask^newone));
    }
    function Check(bytes32 text,bytes32 password)public view userOnly returns(bool){
        return ((text^mask)==password);
    }
}
