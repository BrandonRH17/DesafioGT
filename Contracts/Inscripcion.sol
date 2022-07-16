pragma solidity ^0.4.17;
contract InscripcionFactory {

    address[] public recordDeInscripciones;
    address[] public entidadesInscritas;


    //Siguiente paso: La función inscribirPersona debe ser convertida a tipo External para
    //garantizar que solo ciertas personas la puedan acceder.
    function inscribirPersona(
        uint256 idRgae
    ) public {
        address nuevaPersona = new Inscripcion(
            idRgae,
            msg.sender,
            block.timestamp
        );

        entidadesInscritas.push(msg.sender);
        recordDeInscripciones.push(nuevaPersona);
    }

    function getPersonasInscritas() public view returns (address[]) {
        return entidadesInscritas;
    }

    function getRecordDeInscripciones() public view returns (address[]) {
        return recordDeInscripciones;
    }
}


contract Inscripcion {

    uint256 idRgae;
    address wallet; 
    uint256 fechaDeInscripcion;

  function Inscripcion(
        uint256 idRgaeInscriptor,
        address walletInscriptor,
        uint256 fechaInscripcionInscriptor
    ) public {
        idRgae = idRgaeInscriptor;
        wallet = walletInscriptor;
        fechaDeInscripcion = fechaInscripcionInscriptor;
    }
}
