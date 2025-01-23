// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Voting {

    // Estructura para representar una propuesta
    struct Proposal {
        uint id;
        string description;
        uint votes;
    }

    // Array dinámico de propuestas
    Proposal[] public proposals;

    // Mapping para registrar si una dirección ya votó en una propuesta
    mapping(address => mapping(uint => bool)) public hasVoted;

    // Eventos
    event ProposalAdded(uint id, string description);
    event Voted(address voter, uint proposalId);

    // Función para agregar una nueva propuesta (puede ser pública o restringida)
    function addProposal(string memory _description) external {
        require(bytes(_description).length > 0, "Proposal description cannot be empty");

        uint proposalId = proposals.length; // El ID será el índice en el array
        proposals.push(Proposal(proposalId, _description, 0)); // Crear y agregar la propuesta

        emit ProposalAdded(proposalId, _description); // Emitir evento
    }

    // Función para votar por una propuesta específica
    function vote(uint _proposalId) external {
        require(_proposalId < proposals.length, "Invalid proposal ID"); // Validar ID
        require(!hasVoted[msg.sender][_proposalId], "You have already voted for this proposal"); // Verificar que no haya votado antes

        proposals[_proposalId].votes += 1; // Incrementar los votos de la propuesta
        hasVoted[msg.sender][_proposalId] = true; // Registrar que la dirección ya votó

        emit Voted(msg.sender, _proposalId); // Emitir evento
    }

    // Función para obtener la cantidad total de votos de una propuesta
    function getVotes(uint _proposalId) external view returns (uint) {
        require(_proposalId < proposals.length, "Invalid proposal ID"); // Validar ID
        return proposals[_proposalId].votes; // Retornar el número de votos
    }

    // Función para obtener el detalle de una propuesta
    function getProposal(uint _proposalId) external view returns (uint, string memory, uint) {
        require(_proposalId < proposals.length, "Invalid proposal ID"); // Validar ID
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.id, proposal.description, proposal.votes);
    }

    // Función para obtener el total de propuestas registradas
    function getTotalProposals() external view returns (uint) {
        return proposals.length;
    }
}
