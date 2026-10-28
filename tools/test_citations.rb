# Unit tests for _plugins/citations.rb that need no Jekyll: ruby tools/test_citations.rb
require "minitest/autorun"
require "yaml"
module Liquid; class Tag; def initialize(*); end; end; class Template; def self.register_tag(*); end; end; end
require File.expand_path("../_plugins/citations.rb", __dir__)
C = MyThingsLab::Citations
PAPERS = YAML.load_file(File.expand_path("../_data/papers.yml", __dir__)).to_h { |p| [p["id"], p] }
class CitationsTest < Minitest::Test
  def test_parse
    assert_equal [["a", "b"], {"p"=>"12"}], C.parse("a, b p=12")
    assert_equal [["a"], {"p"=>"3"}], C.parse(' A p="3"')
  end
  def test_order_and_numbers
    src = "x {% cite hopfield-1982 %} y {% citet egnn %} z {%- cite hopfield-1982 demsar-2006 p=4 -%}"
    cited, nums, further, unknown = C.resolve(src, ["egnn", "nemenyi-1963", "nope"], PAPERS)
    assert_equal %w[hopfield-1982 egnn demsar-2006], cited.map { |p| p["id"] }
    assert_equal({"hopfield-1982"=>1,"egnn"=>2,"demsar-2006"=>3}, nums)
    assert_equal %w[nemenyi-1963], further.map { |p| p["id"] }
    assert_equal %w[nope], unknown
  end
  def test_render
    nums = {"demsar-2006"=>1,"hopfield-1982"=>2}
    out = C.render("cite", %w[demsar-2006 hopfield-1982], {"p"=>"12"}, PAPERS, nums)
    assert_match(/\A<span class="cite">\[<a class="cite-link" href="#ref-demsar-2006"/, out)
    assert_includes out, ", p. 12]"
    t = C.render("citet", %w[demsar-2006], {}, PAPERS, nums)
    assert_includes t, ">Demšar (2006)</a> ["
    assert_includes C.render("cite", %w[ghost], {}, PAPERS, nums), "cite-missing"
  end
  def test_short_authors
    assert_equal "Hopfield", C.short_authors("J. J. Hopfield")
    assert_equal "Satorras et al.", C.short_authors("V. G. Satorras, E. Hoogeboom, M. Welling")
    assert_equal "Pedregosa et al.", C.short_authors("F. Pedregosa, G. Varoquaux, et al.")
  end
  def test_timeline_cites
    ctx = {"timeline" => [{"year"=>1982,"text"=>"x","cite"=>"hopfield-1982"}, {"year"=>1985,"text"=>"y"}]}
    assert_equal ["hopfield-1982"], C.timeline_cites(ctx)
    assert_equal [], C.timeline_cites(nil)
  end
  def test_escape_in_title
    p = {"id"=>"x","authors"=>"A. B","year"=>1,"title"=>'a "q" <b>'}
    assert_includes C.link(p,1,nil), "a &quot;q&quot; &lt;b&gt;"
  end
end
