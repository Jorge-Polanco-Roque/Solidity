// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Visibilidad {
    // Visibilidad de las variables
    uint public x = 15;
    uint internal y = 10;
    uint private z = 30;

    // Visibilidad de las funciones
    function get_y() public view returns(uint) {
        return y;
    }

    // Funciones internas: Con private no se podrá accecer
    function get_var_y() private view returns (uint) {
        return y;
    }

    // Funciones internas
    function get_x() internal view returns (uint) {
        return x;
    }

    // Funciones external: Gastan menos que las "public"
    function get_var_x() external view returns (uint) {
        return x;
    }

    // Funciones pure: no accede ni modifica la blockchain
    function get_suma(uint a, uint b) public pure returns (uint) {
        return a+b;
    }

}

contract A is Visibilidad {
    uint public xx = get_x();
}

contract B {
    Visibilidad contrato1 = new Visibilidad();
    uint public var1 = contrato1.get_y();
    uint public var2 = contrato1.get_var_x();
    uint public var3 = contrato1.get_suma(2,3);

}