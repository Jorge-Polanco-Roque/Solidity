//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

contract Visibilidad {
    uint public x = 15;
    uint y = 10;
    uint private z = 30;

    function get_y() public view returns (uint)
    {
        return get_var_y();
    }

    function get_var_y () private view returns (uint)
    {
        return y;
    }

    function get_x () internal view returns (uint){
        return x;
    }

    function get_var_x () external view returns (uint){
        return x;
    }

    function get_suma (uint a, uint b) public pure returns (uint){
        return a+b;
    }
}

contract A is Visibilidad {
    uint public xx = get_x();
   // uint public yy = get_var_y();
}

contract B {
    Visibilidad contrato1 = new Visibilidad();
    uint public var1 = contrato1.get_y();
    uint public var2 = contrato1.get_var_x();
    uint public var3 = contrato1.get_suma(2, 3);


}