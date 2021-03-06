// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
//Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen.
// declare the event
    event NewZombie(uint zombieId, string name, uint dna);

// This will be stored permanently in the blockchain
// Unsigned Integers: uint, meaning its value must be non-negative. 
 
    uint dnaDigits = 16;
    
  
// Addition: x + y, Subtraction: x - y, Multiplication: x * y, Division: x / y
// 10** equal to 10^
//To make sure our Zombie's DNA is only 16 characters, let's make another uint equal to 10^16. That way we can later use the modulus operator % to shorten an integer to 16 digits.    
//eg. n % 5 = I [0, 4], n % 10 = I [0, 9], n % 100 = I [0, 99]
// 10**16 = n % 10000000000000000 =[0,9999999999999999]
    uint dnaModulus = 10 ** dnaDigits;

//Strings are used for arbitrary-length UTF-8 data. eg. string greeting = "Hello world!"
    
    struct Zombie {
        string name;
        uint dna;
    }

// Array with a fixed length of 2 elements: uint[2] fixedArray;
// another fixed Array, can contain 5 strings: string[5] stringArray;
// a dynamic Array - has no fixed size, can keep growing: uint[] dynamicArray;
    
    Zombie[] public zombies;

//specifying the function visibility as private,, it's convention to start private function names with an underscore (_). 
//We're also providing instructions about where the _name variable should be stored- in memory
    
    function _createZombie(string memory _name, uint _dna) private {

//push = Add that Zombie to the Array
//push: Dynamic storage arrays and bytes (not string) have a member function called push() that you can use to append a zero-initialised element at the end of the array. It returns a reference to the element, so that it can be used like x.push().t = 2 or x.push() = b.
//The function returns the new length of the array. So if there is 1 element in the array already, and I push another, that push will return the new length, which is 2. Since arrays are zero-indexed you have to subtract one from the length to get the index of the last element, which is what the code sample you posted is doing.         
        
        uint id = zombies.push(Zombie(_name, _dna)) -1;
        
// fire an event to let the app know the function was called:
        emit NewZombie (id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {

//Ethereum has the hash function keccak256 built in, which is a version of SHA3. A hash function basically maps an input into a random 256-bit hexadecimal number. A slight change in the input will cause a large change in the hash.
//eg. 6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5 -> keccak256(abi.encodePacked("aaaab"));
//eg. b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9 -> keccak256(abi.encodePacked("aaaac"));
//Typecasting = Sometimes you need to convert between data types. eg. uint8 a = 5; uint b = 6; uint8 c = a * b (throws an error because a * b returns a uint, not uint8) 
// we have to typecast b as a uint8 to make it work: uint8 c = a * uint8(b);
        
        uint rand = uint(keccak256(abi.encodePacked(_str)));

// Modulus / remainder: x % y (for example, 13 % 5 is 3, because if you divide 5 into 13, 3 is the remainder)
    
       return rand % dnaModulus;
    }
//create a public function that takes an input, the zombie's name, and uses the name to create a zombie with random DNA.
    
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
