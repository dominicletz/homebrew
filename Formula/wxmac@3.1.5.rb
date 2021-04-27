class WxmacAT315 < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.5/wxWidgets-3.1.5.tar.bz2"
  sha256 "d7b3666de33aa5c10ea41bb9405c40326e1aeb74ee725bb88f90f1d50270a224"
  license "LGPL-2.0-or-later WITH WxWindows-exception-3.1"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git", :tag => "v3.1.5"

  livecheck do
    url "https://github.com/wxWidgets/wxWidgets/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webview",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Set with-macosx-version-min to cover most mac installs
      "--with-macosx-version-min=10.12",
      # Set compat for use in Erlang
      "--enable-compat28",
    ]

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
