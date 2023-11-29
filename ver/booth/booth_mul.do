log -r *
config wave -signalnamewidth 1
add wave *
add wave -position end -color "orange"  sim:/booth_mul_tb/UUT/partial_products
run -all