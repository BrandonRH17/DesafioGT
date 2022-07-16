pragma solidity ^0.4.17;


contract FondoRotativo {
    

    //Siguiente paso: Permitir que la función de Compra() la invoque
    //solamente addresses en el array entidadesInscritas del contrato InscripcionFactory

    uint256 public tipoCompra;
    address public guateCompras;
    address public comprador;
    uint256 public valor;
    uint256 public noc;
    uint256 public fechaPago;
    uint256 public tipoPago;
    bool public abono; 
    uint256 public porcentajeAbono;
    address public vendedor;
    bool public completado;
    bool public cancelado;
    bool public fondeado; 
    bool public compraIniciada;

  
    //Habilita que esta función solo pueda ser llamada por el comprador 
    //que inició la subasta.
    modifier accesoComprador() {
        require(msg.sender == comprador);
        _;
    }

    //Habilita que esta función solo pueda ser llamada por la entidad administrativa
    modifier accesoGuateCompras() {
        require(msg.sender == guateCompras);
        _;
    }
    
    //Habilita que esta función sea llamada media vez la orden de compra no haya sido cancelada
    modifier noCancelado() {
        require(cancelado != true);
        _;
    }

    //Esta función inicia una subasta
    function Compra (
        uint256 valorActual,
        uint256 nocActual, 
        uint256 tipoPagoActual, 
        bool abonoActual,
        uint256 porcentajeAbonoActual,
        address vendedorActual
    ) public {
        comprador = msg.sender;
        valor = valorActual;
        noc = nocActual;
        fechaPago = block.timestamp;
        tipoPago = tipoPagoActual;
        abono = abonoActual;
        vendedor = vendedorActual;
        if (abono == true) {
            require(porcentajeAbonoActual > 0 && porcentajeAbonoActual <= 100);
            porcentajeAbono = porcentajeAbonoActual;
        }
        else {
            porcentajeAbono = 0;
        }

        tipoCompra = 1;
        completado = false;
        cancelado = false;
    }

    //Esta función estaria del lado de Guatecompras. 
    //La tesorería sería la que fondearía el contrato para asegurar los fondos habilitados.
    function fondearCompra() public payable accesoGuateCompras noCancelado{
        require(msg.value == valor);
        require(fondeado == false);
        fondeado = true;
    }

    //Esta función estaría del lado del comprador. 
    //El comprador decide cuando inicia la compra y el pago.
    function iniciarCompra() public accesoComprador noCancelado{
        require(!compraIniciada && fondeado == true) ;
        vendedor.transfer(valor * (porcentajeAbono / 100));
        valor = valor - valor * (porcentajeAbono / 100);
        compraIniciada = true;
    }
    
    //Esta función estaría del lado del comprador o de Guatecompras.
    //Permite cancelar una compra, solo puede ser invocada si la compra no ha sido cancelada previamente.
    function cancelarCompra() public accesoComprador accesoGuateCompras noCancelado{
        cancelado = true;
    }

}

