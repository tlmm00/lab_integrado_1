module Robo (clock, reset, head, left, under, barrier, avancar, girar, remover);
  input clock, reset, head, left, under, barrier;
  output reg avancar, girar, remover;
 
  reg [1:0] EstadoAtual, EstadoFuturo;
 
  parameter
    Iniciando = 3'b000,
    Seguindo = 3'b001,
    AcompanharEsq = 3'b010,
    MeiaVolta = 3'b011,
    Remover1 = 3'b100,
    Remover2 = 3'b101,
    Remover3 = 3'b110,
    StandBy = 3'b111;
    
 
  always @ (negedge clock)
 
  begin
    if(reset)    
      EstadoAtual <= Iniciando;
    else
      EstadoAtual <= EstadoFuturo;
  end
 
  
  always @ (!head or !left or !under or !barrier or EstadoAtual)

  begin
    EstadoFuturo = Iniciando;
    avancar = 1'b1;
    girar = 1'b0;
    remover = 1'b0;
   
    case (EstadoAtual)
     
      Iniciando: begin
          if(barrier) begin
            EstadoFuturo = Remover1;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
			 end
          else if(!head) begin
	         EstadoFuturo = Seguindo;
            avancar = 1'b1;
            girar = 1'b0;
            remover = 1'b0;
			 end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
			 end
        end
      
      Seguindo:
        begin
          if(under) begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
			 end
          else if(!head && barrier) begin
            EstadoFuturo = Remover1;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
			 end
          else if(!head && left) begin
            EstadoFuturo = Seguindo;
            avancar = 1'b1;
            girar = 1'b0;
            remover = 1'b0;
		    end
          else if(!left) begin
            EstadoFuturo = AcompanharEsq;
            avancar = 1'b0;
            girar = 1'b1;
            remover = 1'b0;
		    end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end

      AcompanharEsq:
        begin
          if(!head && !under && barrier) begin
            EstadoFuturo = Remover1;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
		    end
          else if(!head && !left && !under && !barrier) begin
            EstadoFuturo = AcompanharEsq;
            avancar = 1'b1;
            girar = 1'b0;
            remover = 1'b0;
		    end
          else if(!head && left && !under && !barrier) begin
            EstadoFuturo = Seguindo;
            avancar = 1'b1;
            girar = 1'b0;
            remover = 1'b0;
		    end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end

      MeiaVolta:
        begin
          if(!under && barrier) begin
            EstadoFuturo = Remover1;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
		    end
          else if(!under) begin
            if(!head && left) begin
              EstadoFuturo = Seguindo;
              avancar = 1'b1;
              girar = 1'b0;
              remover = 1'b0;
		      end
            else begin
              EstadoFuturo = MeiaVolta;
              avancar = 1'b0;
              girar = 1'b1;
              remover = 1'b0;
		      end
			 end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end

      Remover1:
        begin
          if(!head && barrier) begin
            EstadoFuturo = Remover2;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
		    end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end

      Remover2:
        begin
          if(!head && barrier) begin
            EstadoFuturo = Remover3;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
		    end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end

      Remover3:
        begin
          if(!head && barrier) begin
            EstadoFuturo = Remover3;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b1;
		    end
          else if(!left) begin
            EstadoFuturo = AcompanharEsq;
            avancar = 1'b0;
            girar = 1'b1;
            remover = 1'b0;
		    end
          else if(!head) begin
            EstadoFuturo = Seguindo;
            avancar = 1'b1;
            girar = 1'b0;
            remover = 1'b0;
		    end
          else begin
            EstadoFuturo = StandBy;
            avancar = 1'b0;
            girar = 1'b0;
            remover = 1'b0;
		    end
        end
		 
		 StandBy:
			begin
           EstadoFuturo = StandBy;
           avancar = 1'b0;
           girar = 1'b0;
           remover = 1'b0;
			end


    endcase
 
  end

endmodule
