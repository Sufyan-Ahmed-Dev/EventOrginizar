// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

contract EventOrginaizar {
    struct Event {
        address orginzaizar;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping(uint256 => Event) public Events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public EventID;

    function CreateEvent(
        string memory _name,
        uint256 _date,
        uint256 _price,
        uint256 _ticketCount
    ) public {
        require(_date > block.timestamp, "Event For Future");
        require(_ticketCount > 0, "Ticket Count Must be Equal to 0 ");
        Events[EventID] = Event(
            msg.sender,
            _name,
            _date,
            _price,
            _ticketCount,
            _ticketCount
        );
        EventID++;
    }

    function BuyTicket(uint256 _eventId, uint256 _quantity) public payable {
        require(Events[_eventId].date != 0, "Event does't exists");
        require(
            Events[_eventId].date > block.timestamp,
            "Event has been clossed"
        );
        require(
            msg.value == Events[_eventId].price * _quantity,
            "Price should be equal "
        );
        require(
            Events[_eventId].ticketRemain >= _quantity,
            "Ticket is not Enough"
        );
        Events[_eventId].ticketRemain -= _quantity;
        tickets[msg.sender][_eventId] += _quantity;
    }

    function TicketTransfer(
        address _to,
        uint256 _eventId,
        uint256 _quantity
    ) public {
        require(Events[_eventId].date != 0, "Event does't exists");
        require(
            Events[_eventId].date > block.timestamp,
            "Event has been clossed"
        );
        require(
            tickets[msg.sender][_eventId] >= _quantity,
            "You do not have Enough Ticket"
        );
        tickets[msg.sender][_eventId] -= _quantity;
        tickets[_to][_eventId] += _quantity;
    }
}
