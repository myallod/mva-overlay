# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

DESCRIPTION="A project automation and build tool with a Groovy based DSL"
SRC_URI="http://services.gradle.org/distributions/${P}-src.zip"
HOMEPAGE="http://www.gradle.org/"
LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/zip
	app-eselect/eselect-gradle
"
RDEPEND=">=virtual/jdk-1.5"
IUSE="doc"

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	local inst_target="install"
	use doc && inst_target="installAll"
	./gradlew --gradle-user-home "${WORKDIR}" "${inst_target}" -Pgradle_installPath=dist || die 'Gradle build failed'
}

src_install() {
	local gradle_dir="${EROOT}usr/share/${PN}-${SLOT}"

	cd dist;
	dodoc getting-started.html

	insinto "${gradle_dir}"

	# jars in lib/
	# Note that we can't strip the version from the gradle jars,
	# because then gradle won't find them.
	cd lib;
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	# plugins in lib/plugins
	cd plugins;
	java-pkg_jarinto ${JAVA_PKG_JARDEST}/plugins
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	java-pkg_dolauncher "${P}" --main org.gradle.launcher.GradleMain --java_args "-Dgradle.home=${gradle_dir}/lib \${GRADLE_OPTS}"
}

pkg_postinst() {
	eselect gradle update ifunset
}

pkg_postrm() {
	eselect gradle update ifunset
}
