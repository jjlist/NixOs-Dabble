# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fogTest"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  services.connman.enable = true;

  # Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus18";
  # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
 	 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.devops = {
    isNormalUser = true;
    home = "/home/devops";
    extraGroups = [ "wheel" "networkmanager" "video" "power" ]; # Enable ‘sudo’ for the user.
  # shell = "${pkgs.bash}/bin/bash" 
    packages = with pkgs; [
  #   firefox
      tree
    ];
  };

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  # Proprietary
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bash
    bat
    btop
    cargo
    chromium
    connman-gtk
    fastfetch
    fd
    fzf
    git
    go
    htop
    iotop
    libgcc
    gcc
    mc
    neovim
    nitrogen
    nix-output-monitor
    nodejs
    nvd
    obconf
    pciutils
    ripgrep 
    rofi
    tlrc
    tmux
    usbutils
    wget
    zig
    zellij
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.npm.enable = true;
  programs.thunar.enable = true;
  programs.fzf.keybindings = true;
  programs.fzf.fuzzyCompletion = true;

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    dbus.enable    = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout  = "us, ru";
    xkb.options = "caps:escape";

    videoDrivers = [ "modsetting" ];
    
    windowManager.awesome.enable   = true;

    displayManager = {
      autoLogin.enable = true;
      autoLogin.user   = "devops";
      defaultSession   = "none+awesome";
      sessionCommands  = ''
      picom &
      awesome
      '';
      sddm = {
        #theme      = "sddm-shugar-dark";
        autoNumlock = true;
        enable      = true;
      };
    };
  };

  services.picom.enable = true;

  environment.variables = {
    EDITOR   = "nvim";
    BROWSER  = "chromium";
    TERMINAL = "alacritty";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Mononoki" "JetBrainsMono" "IosevkaTerm" ]; })
  ];
 
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

