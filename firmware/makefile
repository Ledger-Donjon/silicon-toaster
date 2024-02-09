# This is a very poor makefile to build the binary and call objcopy after.
# See issue #1
clean:
	cargo clean
	rm silicontoaster.bin

all:
	cargo build --release
	cargo objcopy --release --bin silicontoaster -- -O binary silicontoaster.bin

flash:
	stm32flash -w silicontoaster.bin -v -g 0 /dev/ttyUSB0

