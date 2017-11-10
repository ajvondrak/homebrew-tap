class GitTopics < Formula
  desc 'A collection of git commands to manage independent topic branches'
  homepage 'https://github.com/ajvondrak/git-topics'
  url 'https://github.com/ajvondrak/git-topics/releases/download/v0.1.0/git-topics-0.1.0.tar.gz'
  sha256 'ef5ebed1b9910ae453364840d926d60225232e4bc32d0d750b35b33b09161bec'
  head 'https://github.com/ajvondrak/git-topics'

  depends_on 'git'
  depends_on 'bash'

  def install
    libexec.install Dir['libexec/*']

    (bin/'git-topics').write <<~EOS
      #!/usr/bin/env bash
      exec "#{libexec}/bin/git-topics" "$@"
    EOS

    man1.install Dir['man/*.1']
    man7.install Dir['man/*.7']

    bash_completion.install 'completions/bash/git-topics'
    zsh_completion.install 'completions/zsh/_git-topics'
  end

  test do
    ENV['GIT_EDITOR'] = 'echo'

    system 'git', 'init'
    system 'git', 'config', 'user.name', 'Homebrew'
    system 'git', 'config', 'user.email', 'test@brew.sh'
    system 'git', 'commit', '--allow-empty', '-m', 'root'
    system bin/'git-topics', '-h' # smoke test the binary directly

    system 'echo "master\ndevelop\n" | git topics setup'

    heads = 'git for-each-ref --format="%(refname:short)" refs/heads'
    assert_equal ["develop\n", "master\n"], shell_output(heads).lines.sort

    list = 'git topics list --porcelain'
    assert_equal '', shell_output(list).strip

    system 'git', 'topics', 'start', 'topic'
    assert_equal 'topic', shell_output('git symbolic-ref --short HEAD').strip

    system 'git', 'commit', '--allow-empty', '-m', 'test'
    assert_equal '- topic', shell_output(list).strip

    system 'git', 'topics', 'integrate', 'topic'
    assert_equal '+ topic', shell_output(list).strip

    system 'git', 'topics', 'finish', 'topic'
    assert_equal '* topic', shell_output(list).strip
  end
end
