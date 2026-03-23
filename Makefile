APP_NAME = ccnotify
APP_BUNDLE = $(APP_NAME).app
BUNDLE_DIR = $(APP_BUNDLE)/Contents
MACOS_DIR = $(BUNDLE_DIR)/MacOS
RESOURCES_DIR = $(BUNDLE_DIR)/Resources
INSTALL_APP_DIR = /Applications
INSTALL_BIN_DIR = /usr/local/bin

.PHONY: build icon install uninstall clean

build: icon
	swiftc $(APP_NAME).swift -o $(MACOS_DIR)/$(APP_NAME)
	codesign --force --deep --sign - $(APP_BUNDLE)

icon: $(RESOURCES_DIR)/AppIcon.icns

$(RESOURCES_DIR)/AppIcon.icns: icon.svg
	@mkdir -p icon.iconset $(RESOURCES_DIR)
	@for size in 16 32 64 128 256 512 1024; do \
		if [ $$size -eq 1024 ]; then \
			name="icon_512x512@2x.png"; \
		else \
			name="icon_$${size}x$${size}.png"; \
		fi; \
		sips -s format png icon.svg --resampleWidth $$size --out "icon.iconset/$$name" >/dev/null 2>&1; \
	done
	@for size in 16 32 128 256; do \
		double=$$((size * 2)); \
		cp "icon.iconset/icon_$${double}x$${double}.png" "icon.iconset/icon_$${size}x$${size}@2x.png"; \
	done
	@cp icon.iconset/icon_128x128.png icon.iconset/icon_32x32@2x.png
	@rm -f icon.iconset/icon_64x64.png
	iconutil -c icns icon.iconset -o $(RESOURCES_DIR)/AppIcon.icns

install: build
	@rm -rf $(INSTALL_APP_DIR)/$(APP_BUNDLE)
	cp -R $(APP_BUNDLE) $(INSTALL_APP_DIR)/$(APP_BUNDLE)
	@mkdir -p $(INSTALL_BIN_DIR)
	@echo '#!/bin/bash' > $(INSTALL_BIN_DIR)/$(APP_NAME)
	@echo 'open -W $(INSTALL_APP_DIR)/$(APP_BUNDLE) --args "$$@"' >> $(INSTALL_BIN_DIR)/$(APP_NAME)
	@chmod +x $(INSTALL_BIN_DIR)/$(APP_NAME)
	@echo "Installed! Run: ccnotify \"your message\""

uninstall:
	rm -rf $(INSTALL_APP_DIR)/$(APP_BUNDLE)
	rm -f $(INSTALL_BIN_DIR)/$(APP_NAME)
	@echo "Uninstalled."

clean:
	rm -rf icon.iconset
	rm -f $(MACOS_DIR)/$(APP_NAME)
	rm -f $(RESOURCES_DIR)/AppIcon.icns
