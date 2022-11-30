pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IExerciceSolution.sol";


contract ExerciceSolution is IExerciceSolution , ERC721
{
    constructor() ERC721("LucasNFT", "LFT") public {}

    event NewAnimal(uint sex, uint legs, bool wings, string name);

    mapping(address => bool) public isAuthorized;

    mapping(address => uint) public ownerToId;

    mapping(uint => address) public idToOwner;

    mapping(uint => uint) public priceOfAnimal;

    mapping(uint => bool)public isForSale;

    struct Animal{
        uint sex;
        uint legs;
        bool wings;
        string name;
    }
    
    Animal[] public animals;

    // mapping (address => EnumerableSet.UintSet) private _holderTokens;
    // EnumerableMap.UintToAddressMap private _tokenOwners;

	// Breeding function
	function isBreeder(address account) external override returns (bool){
        isAuthorized[account] = true;
        return(isAuthorized[account]);
    }

	function registrationPrice() external override returns (uint256){
        return 1;
    }

	function registerMeAsBreeder() external override payable{
        require(msg.value == 1);
        isAuthorized[msg.sender] = true;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return 10;
    }

	function declareAnimal(uint sex, uint legs, bool wings, string calldata name) external override returns (uint256){
        require(isAuthorized[msg.sender] == true);
        animals.push(Animal(sex, legs, wings, name));
        uint id = animals.length-1;
        _mint(msg.sender, id);
        ownerToId[msg.sender] = id;
        idToOwner[id] = msg.sender;
        emit NewAnimal(sex, legs, wings, name);
        return id;
    }


	function getAnimalCharacteristics(uint animalNumber) external override returns (string memory _name, bool _wings, uint _legs, uint _sex){
        _name = animals[animalNumber].name;
        _wings = animals[animalNumber].wings;
        _legs = animals[animalNumber].legs;
        _sex = animals[animalNumber].sex;
        return(_name, _wings, _legs, _sex);
    }

	function declareDeadAnimal(uint animalNumber) external override{
        require(msg.sender == idToOwner[animalNumber]);
        _burn(animalNumber);
        animals[animalNumber].name = "";
        animals[animalNumber].wings = false;
        animals[animalNumber].legs = 0;
        animals[animalNumber].sex = 0;
        idToOwner[animalNumber] = 0x0000000000000000000000000000000000000000;
    }

	function tokenOfOwnerByIndex(address owner, uint256 index) public view override(ERC721, IExerciceSolution) returns (uint256){
        return ownerToId[owner];
    }

	// Selling functions
	function isAnimalForSale(uint animalNumber) external view override returns (bool){
        return isForSale[animalNumber];
    }

	function animalPrice(uint animalNumber) external view override returns (uint256){
        return priceOfAnimal[animalNumber];
    }

	function buyAnimal(uint animalNumber) external payable override{
        require(isForSale[animalNumber] == true);
        require(priceOfAnimal[animalNumber] == msg.value);
        address owner = idToOwner[animalNumber];
        _transfer(owner ,msg.sender, animalNumber);
    }

	function offerForSale(uint animalNumber, uint price) external override{
        require(msg.sender == idToOwner[animalNumber]);
        priceOfAnimal[animalNumber] = price;
        isForSale[animalNumber] = true;
    }
	// Reproduction functions

	function declareAnimalWithParents(uint sex, uint legs, bool wings, string calldata name, uint parent1, uint parent2) external override returns (uint256){

    }

	function getParents(uint animalNumber) external override returns (uint256, uint256){

    }

	function canReproduce(uint animalNumber) external override returns (bool){

    }

	function reproductionPrice(uint animalNumber) external view override returns (uint256){

    }

	function offerForReproduction(uint animalNumber, uint priceOfReproduction) external override returns (uint256){

    }

	function authorizedBreederToReproduce(uint animalNumber) external override returns (address){

    }

	function payForReproduction(uint animalNumber) external payable override{

    }
}
