//****************************************Copyright (c)***********************************//
// Module name:           ascii_to_num
// Description:           ASCII字符转数字模块
//                        将接收到的ASCII字符'0'-'9'转换为4位数字0-9
//                        支持空格作为分隔符
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ascii_to_num(
    input               clk         ,   // 系统时钟
    input               rst_n       ,   // 系统复位，低电平有效
    input               data_valid  ,   // 输入数据有效信号
    input      [7:0]    ascii_data  ,   // 输入ASCII数据
    output reg          num_valid   ,   // 输出数字有效信号
    output reg [3:0]    num_data    ,   // 输出数字数据(0-9)
    output reg          is_space        // 是否为空格分隔符
);

//*****************************************************
//**                    main code
//*****************************************************

// ASCII码定义
localparam ASCII_0     = 8'd48;     // '0'
localparam ASCII_9     = 8'd57;     // '9'
localparam ASCII_SPACE = 8'd32;     // 空格
localparam ASCII_LF    = 8'd10;     // 换行符'\n'
localparam ASCII_CR    = 8'd13;     // 回车符'\r'

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        num_valid <= 1'b0;
        num_data  <= 4'd0;
        is_space  <= 1'b0;
    end
    else if(data_valid) begin
        // 判断是否为数字字符'0'-'9'
        if(ascii_data >= ASCII_0 && ascii_data <= ASCII_9) begin
            num_valid <= 1'b1;
            num_data  <= ascii_data[3:0];  // ASCII码的低4位就是数字值
            is_space  <= 1'b0;
        end
        // 判断是否为空格或换行符(作为分隔符)
        else if(ascii_data == ASCII_SPACE ||
                ascii_data == ASCII_LF ||
                ascii_data == ASCII_CR) begin
            num_valid <= 1'b1;
            num_data  <= 4'd0;
            is_space  <= 1'b1;
        end
        // 其他字符忽略
        else begin
            num_valid <= 1'b0;
            num_data  <= 4'd0;
            is_space  <= 1'b0;
        end
    end
    else begin
        num_valid <= 1'b0;
        num_data  <= num_data;
        is_space  <= 1'b0;
    end
end

endmodule
