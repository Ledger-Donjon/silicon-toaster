# This is a very poor makefile to build the binary and call objcopy after.
# See issue #1
clean:
	cargo clean
	rm -f silicontoaster.bin silicontoaster.debug.bin

all:
	cargo build --release
	cargo build
	cargo objcopy --release --bin silicontoaster -- -O binary silicontoaster.bin
	cargo objcopy --bin silicontoaster -- -O binary silicontoaster.debug.bin

flash:
	stm32flash -w silicontoaster.bin -v -g 0 /dev/ttyUSB0

flash-debug:
	stm32flash -w silicontoaster.debug.bin -v -g 0 /dev/ttyUSB0

