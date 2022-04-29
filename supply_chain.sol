pragma solidity ^0.4.17; 

contract Mask {
    function GenerateMask(string text)public;
    function refreshMask(address sender,uint time)public;
    function Check(bytes32 text,bytes32 password)public view returns(bool);
}
contract Inbox {
    struct node{
        bytes32 password;
        uint refreshTime;
        address Account;
        address MaskAddress;
        bool lock;
    }
    node[5] private client;
    address private owner;
    
    constructor() public{
        owner = msg.sender;
    }
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    function random() private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%251);
    }
    function SetClient(string newPassword,uint newNumber,address client_addr,address mask_addr) public ownerOnly{
        require(newNumber<5 && newNumber>=0);
        Mask m=Mask(mask_addr);
        m.GenerateMask(newPassword);
        client[newNumber].refreshTime=random();
        client[newNumber].password=sha256(abi.encodePacked(newPassword));
        client[newNumber].MaskAddress=mask_addr;
        client[newNumber].Account=client_addr;
        client[newNumber].lock=true;
    }
    function askTime()external view returns(uint){
        uint num=0;
        for(;num<5;num++){
            if(client[num].Account==msg.sender){
                break;
            }
        }
        if(num>=5){
            revert("Wrong Account");
        }
        else{
            return client[num].refreshTime;    
        }
    }
    function Verify(uint Number,bytes32 Password)public{
        require(Number<5 && Number>=0);
        require(client[Number].lock);
        Mask m=Mask(client[Number].MaskAddress);
        m.refreshMask(client[Number].Account,client[Number].refreshTime);
        if(m.Check(Password,client[Number].password)){
            client[Number].refreshTime=random();
            client[Number].password=client[Number].password^(sha256(abi.encodePacked(msg.sender)));
            client[Number].Account=msg.sender;
        }
        else{
            revert("Wrong password");
        }
    }
}
