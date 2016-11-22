{
  foreman = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18vdqrb5dy9kab70dxp41phznxzxkk30g02nq4nkwivdcwkj0arm";
      type = "gem";
    };
    version = "0.82.0";
  };
  puma = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1msxx5yxgb0p76p3si5gwgjar7d5vza05fng71i2lmnp0rq6118z";
      type = "gem";
    };
    version = "3.4.0";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
      type = "gem";
    };
    version = "1.6.4";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  redis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v68ggm0pwcyml3ngfyngwgvypwmsrmji1kyx48qqcg045zjs5p6";
      type = "gem";
    };
    version = "3.3.0";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b81kbr65mmcl9cdq2r6yc16wklyp798rxkgmm5pr9fvsj7jwmxp";
      type = "gem";
    };
    version = "1.4.7";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lgk8bfx24959yq1cn55php3321wddw947mgj07bxfnwyipy9hqf";
      type = "gem";
    };
    version = "2.0.5";
  };
}