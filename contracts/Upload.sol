// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract Upload
{ 
    struct Access
    {
        address user;
        bool access;
    }
    mapping(address=>Access[]) public access_List;  // #abc  --->         #def       #efg       #ghd
                                                   //                     true       False       true
//_______________________________________________________________________________________________________________________________________________
    //dynamic array
    mapping(address=>string[]) value;      // #abc  --->      IMG1       IMG2       IMG3

//_______________________________________________________________________________________________________________________________________________
 
    mapping(address=>mapping(address=>bool)) ownership;  // Nested mapping   , GIVE owndership of IMG to anothor User

    //               adr1        adr2        adr3
    //      adr1       T           F           F
    //      adr2       F           F           T
    //      adr3       T           F           F

//_______________________________________________________________________________________________________________________________________________

    mapping(address=>mapping(address=>bool)) previous_data;  // use for avoid duplication   access_List[msg.sender].push(Access(#123,true));    ----agian---->   access_List[msg.sender].push(Access(#123,true));

//_______________________________________________________________________________________________________________________________________________

    function add(address user_, string calldata url_) external
    {
        value[user_].push(url_);
    }

    function allow(address user_) external  // msg.sender giving access of his/her Drive to user_
    {
        (ownership[msg.sender])[user_] = true;
        if((previous_data[msg.sender])[user_] == true )  //true meaning address exit in access_list-> now allow them
        {
            for(uint i=0;i<access_List[msg.sender].length;i++)  
            {
                if((access_List[msg.sender])[i].user == user_)
                {
                    (access_List[msg.sender])[i].access = true;
                }
            }
        }
        else
        {
            (previous_data[msg.sender])[user_] = true;
            access_List[msg.sender].push(Access(user_,true));
        }
    }

    function disallow(address user_) external //msg.sender remove access from user_(if any user_ exists)
    {
        (ownership[msg.sender])[user_] = false;
        for(uint i=0;i<access_List[msg.sender].length;i++)  
        {
            if((access_List[msg.sender])[i].user == user_)
            {
                (access_List[msg.sender])[i].access = false;
            }
        }

    }

    function display(address user_) external view returns(string [] memory)  // display image uploaded by user_ that was shared with me(msg.sender)
    {
        require(user_ == msg.sender || ownership[user_][msg.sender],"you don't have access");
        return value[user_];
    }

    function share_access() external view returns(Access[] memory)
    {
        return access_List[msg.sender];
    }



}
// 0x5fbdb2315678afecb367f032d93f642f64180aa3