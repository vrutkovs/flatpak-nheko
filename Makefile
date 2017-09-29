all: install-deps build prune install-repo
	flatpak update --user com.github.mujx.Nheko

install-deps:
	flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user install flathub org.kde.Platform//5.9 org.kde.Sdk//5.9 || true

build:
	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
		--subject="Nightly build of Nheko, `date`" \
		${EXPORT_ARGS} app com.github.mujx.Nheko.json

prune:
	flatpak build-update-repo --prune --prune-depth=20 repo

install-repo:
	flatpak --user remote-add --if-not-exists --no-gpg-verify nightly-nheko ./repo
	flatpak --user -v install nightly-nheko com.github.mujx.Nheko || true
