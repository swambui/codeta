# Simple makefile to clean up junk

clean:
	rm -f $(wildcard /tmp/codeta-*.log)
	rm -f $(wildcard codeta/*.pyc)
	rm -f $(wildcard codeta/*/*.pyc)
