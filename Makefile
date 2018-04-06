all: prepare-repo install-deps build clean-cache update-repo

prepare-repo:
	[[ -d repo ]] || ostree init --mode=archive-z2 --repo=repo
	[[ -d repo/refs/remotes ]] || mkdir -p repo/refs/remotes && touch repo/refs/remotes/.gitkeep

install-deps:
	flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user install flathub org.kde.Platform/x86_64/5.9 org.kde.Sdk/x86_64/5.9 org.freedesktop.Sdk.Extension.gcc7

build:
	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
		--subject="Nightly build of Nheko, `date`" \
		${EXPORT_ARGS} app com.github.mujx.Nheko.json

clean-cache:
	rm -rf .flatpak-builder/build

update-repo:
	flatpak build-update-repo --prune --prune-depth=20 --generate-static-deltas repo
	echo 'gpg-verify-summary=false' >> repo/config
install-repo:
	flatpak --user remote-add --if-not-exists --no-gpg-verify local-nheko ./repo
	flatpak --user -v install local-nheko com.github.mujx.Nheko || true
