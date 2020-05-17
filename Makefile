cat: cat.zig
	zig build-exe cat.zig --release-fast

clean:
	\rm -f cat cat.o

cross: cat.zig
	zig build-exe cat.zig -target x86_64-linux-gnu --release-fast

fmt:
	zig fmt cat.zig

.PHONY: clean fmt
