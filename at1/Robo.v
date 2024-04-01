module Robo (clock, reset, head, left, avancar, girar);
  input clock, reset, head, left;
  output reg avancar, girar;
 
  reg [1:0] EstadoAtual, EstadoFuturo;
 
  parameter
    ProcurandoMuro = 2'b00,
    Rotacionando = 2'b01,
    AcompanhandoMuro = 2'b10;
 
  always @ (negedge clock)
 
  begin
    if(reset)    
      EstadoAtual <= ProcurandoMuro;
    else
      EstadoAtual <= EstadoFuturo;
  end
 
  
  always @ (head or left or EstadoAtual)

  begin
    EstadoFuturo = ProcurandoMuro;
    avancar = 1'b1;
    girar = 1'b0;
   
    case (EstadoAtual)
     
      ProcurandoMuro: case ({head, left})
      2'b00:
        begin
          EstadoFuturo = ProcurandoMuro;
          avancar = 1'b1;
          girar = 1'b0;
        end

      2'b01:
        begin
          EstadoFuturo = AcompanhandoMuro;
          avancar = 1'b1;
          girar = 1'b0;
        end
     
      2'b10:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end
       
      2'b11:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end

    endcase
 
 
      Rotacionando: case ({head, left})
      2'b00:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end

      2'b01:
        begin
          EstadoFuturo = AcompanhandoMuro;
          avancar = 1'b1;
          girar = 1'b0;
        end
     
      2'b10:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end
       
      2'b11:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end

    endcase

 
      AcompanhandoMuro: case ({head, left})
      2'b00:
        begin
          EstadoFuturo = ProcurandoMuro;
          avancar = 1'b0;
          girar = 1'b1;
        end

      2'b01:
        begin
          EstadoFuturo = AcompanhandoMuro;
          avancar = 1'b1;
          girar = 1'b0;
        end
     
      2'b10:
        begin
          EstadoFuturo = ProcurandoMuro;
          avancar = 1'b0;
          girar = 1'b1;
        end
       
      2'b11:
        begin
          EstadoFuturo = Rotacionando;
          avancar = 1'b0;
          girar = 1'b1;
        end

    endcase

  endcase
 
  end

endmodule
