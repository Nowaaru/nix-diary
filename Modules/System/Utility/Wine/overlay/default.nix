self: super:
{
	wine64 = super.wine64.overrideAttrs (old: {
		src = super.fetchurl {
			url = "https://dl.winehq.org/wine/source/9.0/wine-9.0-rc2.tar.xz";
			hash = "sha256-2dfMC7TKvCiugOBU6HQ7zqpQ3Pxqwv2b9BnerfpDBm8=";
		};
	});
}
