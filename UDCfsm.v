module UDCfsm
(
    input sens_front, sens_back, rst,
    output reg fflag , eflag,
    output reg [ 2 : 0] p_count
);
reg [2:0] case_reg;
integer pinq=0;
initial begin
    $display("please, reset the system for starting.");
end
always @(negedge sens_front or negedge sens_back or negedge rst) begin
	 if(rst==0) begin
        pinq = 0;
        eflag <= 1'b1;
        fflag <= 1'b0;
        case_reg <= 'b0;
        $display("Refreshed. system is ready!");
    end
    else begin
      case (case_reg)
          'b0  : begin
            eflag <= 1'b1;
            fflag <= 1'b0;
            $display("the queue is empty, ready for service!");
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b001;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = 0;
            case_reg <= 'b0;
            eflag <= 1'b1;
            fflag <= 1'b0;
            $display("NOTE! if you trying to enter please enter from the entry gate."); //if someone tries to leave while no one actually in the queue
          end
          else begin
            eflag <= 1'b1;
            fflag <= 1'b0;
            case_reg <= 'b0;
            pinq = 0;
            $display("the queue is empty, ready for service!");
          end
        end

          'b001 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b010;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b0;
            eflag <= 1'b1;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b001;
            pinq = pinq;
          end
          end

          'b010 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b011;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b001;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b010;
            pinq = pinq;
          end
          end

          'b011 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b100;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b010;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b011;
            pinq = pinq;
          end
          end

          'b100 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b101;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b011;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b100;
            pinq = pinq;
          end
          end

          'b101 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b110;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b100;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b101;
            pinq = pinq;
          end
          end

          'b110 : begin
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b111;
            eflag <= 1'b0;
            fflag <= 1'b1;
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b101;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b0;
            case_reg <= 'b110;
            pinq = pinq;
          end
          end

          'b111 : begin
          if(~sens_front)begin
            pinq = pinq;
            case_reg <= 'b111;
            eflag <= 1'b0;
            fflag <= 1'b1;
            $display("WARNING! the queue is full, please take a seat for now!");
          end
          else if(~sens_back)begin
            pinq = pinq - 1;
            case_reg <= 'b110;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else begin
            eflag <= 1'b0;
            fflag <= 1'b1;
            case_reg <= 'b111;
            pinq = pinq;
            $display("The queue is full, please wait for your turn.");
          end
          end

          default: begin
            eflag <= 1'b1;
            fflag <= 1'b0;
            $display("the queue is empty, ready for service!");
          if(~sens_front)begin
            pinq = pinq + 1;
            case_reg <= 'b001;
            eflag <= 1'b0;
            fflag <= 1'b0;
          end
          else if(~sens_back)begin
            pinq = 0;
            case_reg <= 'b0;
            eflag <= 1'b1;
            fflag <= 1'b0;
            $display("NOTE! if you trying to enter please enter from the entry gate."); //if someone tries to leave while no one actually in the queue
          end
          else begin
            eflag <= 1'b1;
            fflag <= 1'b0;
            case_reg <= 'b0;
            pinq = 0;
            $display("the queue is empty, ready for service!");
          end
        end
      endcase
    end
    
p_count <= pinq;
$display("at time %d : There are %d client(s) waiting.", $time, pinq);
end
endmodule