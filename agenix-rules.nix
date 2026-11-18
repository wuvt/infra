let
	strip = s: builtins.replaceStrings [ "\n"] [ "" ] s;

	hostNames = builtins.attrNames (builtins.readDir ./hosts);

	hostKeyPath = host: "hosts/${host}/keys/ssh_host_ed25519_key";

	masterKeys = map (name: strip (builtins.readFile (./keys/masters + "/${name}"))) (builtins.attrNames (builtins.readDir ./keys/masters));

	iso-id = strip (builtins.readFile ./keys/iso-id.pub);


	hostKey = host: strip (builtins.readFile (./. + "/${hostKeyPath host}.pub"));

	hostKeys = map hostKey hostNames;

	hostKeySecrets = builtins.listToAttrs (map (host: {name = "${hostKeyPath host}.age"; value.publicKeys = [ iso-id ];}) hostNames);
in
hostKeySecrets
// {
	"secrets/iso-id.age".publicKeys = masterKeys;
	"secrets/ladmin-password.age".publicKeys = masterKeys ++ hostKeys;
	"secrets/am-trackman-password.age".publicKeys = masterKeys ++ [ (hostKey "banqiao") ];
}
