`timescale 1ns/1ns

module Robo_TB;

parameter N = 2'b00, S = 2'b01, L = 2'b10, O = 2'b11;

reg clock, reset, head, left;
wire avancar, girar;

reg [1:20] Mapa [0:20]; // linha 0 reservada para posicao do robo e quantidade de movimentos
reg [1:20] Linha_Mapa;
reg [1:5] Linha_Robo;
reg [1:5] Coluna_Robo;
reg [1:2] Orientacao_Robo; 
reg [1:8] Qtd_Movimentos;
reg [1:48] String_Orientacao_Robo;
integer i;

Robo DUV (.clock(clock), .reset(reset), .head(head), .left(left), .avancar(avancar), .girar(girar));

always
	#50 clock = !clock;

initial
begin
	clock = 0;
	reset = 1;
	head = 0;
	left = 0;

	$readmemb("Mapa.txt", Mapa);
	Linha_Mapa = Mapa[0];
	Linha_Robo = Linha_Mapa[1:5];
	Coluna_Robo = Linha_Mapa[6:10];
	Orientacao_Robo = Linha_Mapa[11:12];
	Qtd_Movimentos = Linha_Mapa[13:20];
	$display ("Linha = %d Coluna = %d Orientacao = %s Movimentos = %d", Linha_Robo, Coluna_Robo, String_Orientacao_Robo, Qtd_Movimentos);

	if (Situacoes_Anomalas(1)) $stop;

	#100 @ (negedge clock) reset = 0; // sincroniza com borda de descida

	for (i = 0; i < Qtd_Movimentos; i = i + 1)
	begin
		@ (negedge clock);
		Define_Sensores;
		$display ("H = %b L = %b", head, left);
		@ (negedge clock);
		Atualiza_Posicao_Robo;
		case (Orientacao_Robo)
			N: String_Orientacao_Robo = "Norte";
			S: String_Orientacao_Robo = "Sul  ";
			L: String_Orientacao_Robo = "Leste";
			O: String_Orientacao_Robo = "Oeste";
		endcase
		$display ("Linha = %d Coluna = %d Orientacao = %s", Linha_Robo, Coluna_Robo, String_Orientacao_Robo);
		if (Situacoes_Anomalas(1)) $stop;
	end

	#50 $stop;
end

function Situacoes_Anomalas (input X);
begin
	Situacoes_Anomalas = 0;
	if ( (Linha_Robo < 1) || (Linha_Robo > 20) || (Coluna_Robo < 1) || (Coluna_Robo > 20) )
		Situacoes_Anomalas = 1;
	else
	begin
		Linha_Mapa = Mapa[Linha_Robo];
		if (Linha_Mapa[Coluna_Robo] == 1)
			Situacoes_Anomalas = 1;
	end
end
endfunction

task Define_Sensores;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de head
				if (Linha_Robo == 1)
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo - 1];
					head = Linha_Mapa[Coluna_Robo];
				end
				// definicao de left
				if (Coluna_Robo == 1)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					left = Linha_Mapa[Coluna_Robo - 1];
				end
			end
		S:	begin
				// definicao de head
				if (Linha_Robo == 20)
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo + 1];
					head = Linha_Mapa[Coluna_Robo];
				end
				// definicao de left
				if (Coluna_Robo == 20)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					left = Linha_Mapa[Coluna_Robo + 1];
				end
			end
		L:	begin
				// definicao de head
				if (Coluna_Robo == 20)
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					head = Linha_Mapa[Coluna_Robo + 1];
				end
				// definicao de left
				if (Linha_Robo == 1)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo - 1];
					left = Linha_Mapa[Coluna_Robo];
				end
			end
		O:	begin
				// definicao de head
				if (Coluna_Robo == 1)
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					head = Linha_Mapa[Coluna_Robo - 1];
				end
				// definicao de left
				if (Linha_Robo == 20)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo + 1];
					left = Linha_Mapa[Coluna_Robo];
				end
			end
	endcase
end
endtask

task Atualiza_Posicao_Robo;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de orientacao / linha / coluna
				if (avancar)
				begin
					Linha_Robo = Linha_Robo - 1;
				end
				else
				if (girar)
				begin
					Orientacao_Robo = O;
				end
			end
		S:	begin
				// definicao de orientacao / linha / coluna
				if (avancar)
				begin
					Linha_Robo = Linha_Robo + 1;
				end
				else
				if (girar)
				begin
					Orientacao_Robo = L;
				end
			end
		L:	begin
				// definicao de orientacao / linha / coluna
				if (avancar)
				begin
					Coluna_Robo = Coluna_Robo + 1;
				end
				else
				if (girar)
				begin
					Orientacao_Robo = N;
				end
			end
		O:	begin
				// definicao de orientacao / linha / coluna
				if (avancar)
				begin
					Coluna_Robo = Coluna_Robo - 1;
				end
				else
				if (girar)
				begin
					Orientacao_Robo = S;
				end
			end
	endcase
end
endtask

endmodule



