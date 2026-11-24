# ARM32 single-cycle · Lab 9

## Chạy chương trình của slide 51–57

Giải nén ZIP. Thư mục gốc là ARM32_Lab9, nơi có run.do và thư mục program. Trong Transcript của ModelSim/Questa, thay đường dẫn bằng thư mục vừa giải nén.

```tcl
cd {D:/MonHoc/ARM32_Lab9}
do run.do
```

Script chọn tb_top, thêm các dây và chạy tới PASS. Transcript phải có hai lần ghi theo thứ tự 100 ← 8 và 104 ← 3. Ở lệnh cuối, PC=28 lặp qua nhiều cạnh. Trong waveform, xem 45–55 ns cho STR thứ nhất và 55–65 ns cho LDR. Dữ liệu ở cổng D có sẵn trước cạnh. Dữ liệu trong thanh ghi đổi sau cạnh. Để chạy riêng các bài thử khác, dùng một trong các lệnh sau.

```tcl
do run.do tb_units
do run.do tb_datapath
do run.do tb_control_cpu
```

## Chạy lại bằng Icarus Verilog

Từ thư mục gốc trên Linux hoặc trong shell có Icarus, gõ:

```sh
iverilog -g2012 -s tb_top -o lab9_sim rtl/common/*.sv rtl/processor/*.sv rtl/top.sv sim/tb_top.sv
vvp lab9_sim +vcd
```

Để xem dạng sóng đã tạo sẵn, mở **sim/reference/lab9.vcd** trong GTKWave. Chọn tb_top → dut → cpu → dp để thêm SrcA, SrcB, ExtImm, Result, PCNext. Nếu chạy lại với +vcd, bản mới là lab9.vcd ở thư mục gốc.

## Mở trong Quartus Prime Lite

Mở ARM32_Lab9.qpf. Cấu hình đi kèm chọn top và chip MAX 10 của DE10-Lite theo slide 49 để xem RTL. Khi dùng chip khác, đổi Device. Chạy Analysis & Synthesis rồi mở Tools → Netlist Viewers → RTL Viewer. Cấu hình này phục vụ xem lõi; để nạp board cần wrapper, gán chân và ràng buộc clock phù hợp. Việc mô phỏng dùng module tb_top làm gốc.

## Từ một mũi tên sang dòng code

| Mở file | Lần theo |
|---|---|
| rtl/top.sv | cpu xuất PC cho imem_i; Instr quay lại cpu. DataAdr, WriteData, MemWrite sang dmem_i. |
| rtl/processor/arm.sv | c tạo control; dp tạo dữ liệu và ALUFlags. |
| rtl/processor/datapath.sv | Tìm tên instance theo thứ tự read_addr2 → rf → operand_b → alu_i → writeback. |
| rtl/common/regfile.sv | Hai cổng đọc tổ hợp. R15 đọc PC+8; R0–R14 ghi cạnh lên. |
| rtl/processor/extend.sv | imm8, imm12, offset nhánh có dấu tính theo byte. |
| rtl/processor/decoder.sv | Giải nhóm lệnh, kiểm tra encoding, yêu cầu RegW, MemW, PCS, FlagW. |
| rtl/processor/condlogic.sv | Flags đã lưu → condcheck → quyền ghi thực tế. Reset chặn ghi. |
| rtl/common/alu.sv | Phép toán và NZCV tổ hợp. Với SUB, C=1 khi không mượn. |

Trong báo cáo, result_MUX là Result trong dp; Result_ALU là ALUResult; rd ở DMEM là ReadData. Tên WriteData trong project luôn là dữ liệu store từ RF.rd2. Giá trị ghi về thanh ghi dùng tên Result/WD3.

## Mã máy và giới hạn

program/lab9.s và tám word đầu của program/memfile.dat là chương trình slide 51–52. Cả hai bộ nhớ có 64 word. Bộ nhớ lệnh đệm bằng EAFFFFFE sau chương trình. R0–R14 và DMEM chưa ghi có thể có X. Reset bất đồng bộ tích cực cao đưa PC và Flags về 0. R0 là thanh ghi thông thường.

Hỗ trợ ADD, SUB, AND, ORR (nguồn Rm không dịch hoặc imm8 không rotate); tùy chọn S; LDR/STR word ở [Rn, #+imm12] không cập nhật Rn; B có dấu theo PC+8. Điều kiện 0–E theo bảng trong condcheck.sv. Mã F và các dạng ngoài subset không tạo tác động kiến trúc ngoài bước PC tuần tự. Dạng DP có S=1 và Rd=15 thuộc cơ chế trả về ngoại lệ, được loại khỏi subset. Với Rd=15 và S=0 hoặc LDR PC, dữ liệu ghi về trở thành PCNext; chương trình phải cung cấp địa chỉ word hợp lệ. Không mô phỏng chuyển sang Thumb.

IMEM/DMEM dùng địa chỉ byte căn 4 trong khoảng 0..252. Nếu đọc sai địa chỉ, đầu ra là X; DMEM chặn ghi sai dải. Testbench kiểm tra địa chỉ trong lần truy cập có hiệu lực. Luồng dữ liệu áp dụng đọc bộ nhớ tổ hợp và ghi RAM đồng bộ.

## Bốn testbench và kết quả

| Testbench | Điều được kiểm tra |
|---|---|
| tb_units | ADD/SUB với carry, mượn, zero, overflow; AND/ORR; 16 điều kiện × 16 tổ hợp NZCV. |
| tb_datapath | Cấp control trực tiếp để thử reset, PC+4, DP reg/imm, LDR, STR và B lùi. |
| tb_top | Tám lệnh trong ROM, dữ liệu sau cạnh, hai lần ghi, kiểm tra địa chỉ và vòng tự nhảy. |
| tb_control_cpu | Chương trình riêng trong control.dat, có bản đối chiếu PC hex ở control.lst. Kiểm tra cập nhật cờ từng nhóm, điều kiện sai chặn ghi, nhánh tới trước, ghi PC bằng ADD/LDR, bỏ qua mã ngoài subset. |

Bốn testbench đã PASS với Icarus Verilog 12.0. Waveform VCD đính kèm là kết quả chạy tb_top. Script ModelSim và project Quartus được cung cấp để mở trên máy thực hành; chưa có kết quả chạy từ hai công cụ đó, chưa đo timing hay nạp FPGA.
