class GitFix < Formula
  desc "A git command to open merge conflicts in Vim's quickfix list"
  homepage "https://github.com/ajvondrak/git-fix"
  url "https://github.com/ajvondrak/git-fix/archive/v1.0.0.tar.gz"
  sha256 "5597d6c3f494a53566afd76ed2e2c4506c6adfe7614de433e51d29b1e7ff5fa1"
  head "https://github.com/ajvondrak/git-fix"
  license "MIT"

  def install
    bin.install "bin/git-fix"
  end
end
