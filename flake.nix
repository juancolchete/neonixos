{

  inputs = {
    # Change this line from nixos-unstable to nixos-25.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    nixified-ai.url = "github:nixified-ai/flake";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixified-ai, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Pass both nixified-ai and home-manager to your modules
      specialArgs = { inherit nixified-ai home-manager; };
      modules = [
        ./configuration.nix
        nixified-ai.nixosModules.comfyui
        # Include the Home Manager module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Optional: point to a separate home.nix if you have one
          # home-manager.users.juanc = import ./home.nix;
        }
      ];
    };
  };
}
