pragma solidity ^0.8.0;

contract RideShare {
    address public owner;
    address[] public drivers;
    mapping(address => Rider) public riders;
    mapping(address => Driver) public driversData;
    mapping(address => Trip) public trips;

    struct Rider {
        address riderAddress;
        string pickupLocation;
        string dropoffLocation;
        uint256 estimatedCost;
    }

    struct Driver {
        address driverAddress;
        bool isAvailable;
    }

    struct Trip {
        address rider;
        address driver;
        uint256 amountPaid;
    }

    event NewRider(address riderAddress, string pickupLocation, string dropoffLocation, uint256 estimatedCost);
    event NewDriver(address driverAddress);
    event NewTrip(address rider, address driver);
    event PaymentReceived(address driver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function registerRider(string memory _pickupLocation, string memory _dropoffLocation, uint256 _estimatedCost) public {
        riders[msg.sender] = Rider(msg.sender, _pickupLocation, _dropoffLocation, _estimatedCost);
        emit NewRider(msg.sender, _pickupLocation, _dropoffLocation, _estimatedCost);
    }

    function registerDriver() public {
        drivers.push(msg.sender);
        driversData[msg.sender] = Driver(msg.sender, true);
        emit NewDriver(msg.sender);
    }

    function getAvailableDrivers() public view returns (address[] memory) {
        address[] memory availableDrivers;
        for (uint256 i = 0; i < drivers.length; i++) {
            if (driversData[drivers[i]].isAvailable) {
                availableDrivers[i] = drivers[i];
            }
        }
        return availableDrivers;
    }

    function selectDriver(address _driver) public {
        trips[msg.sender] = Trip(msg.sender, _driver, 0);
        driversData[_driver].isAvailable = false;
        emit NewTrip(msg.sender, _driver);
    }

    function completePayment(address _driver, uint256 _amount) public {
        require(trips[msg.sender].driver == _driver, "Driver does not match");
        trips[msg.sender].amountPaid += _amount;
        emit PaymentReceived(_driver, _amount);
    }

    function completeTrip() public {
        driversData[trips[msg.sender].driver].isAvailable = true;
        delete trips[msg.sender];
    }
}
