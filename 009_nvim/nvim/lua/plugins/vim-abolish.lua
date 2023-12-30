return {
  "tpope/vim-abolish",
  event = "VeryLazy",
  config = function()
    vim.cmd [[
      Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
      Abolish {,non}existan{ce,t}                           {}existen{}
      Abolish {,in}consistan{cy,cies,t,tly}                 {}consisten{}
      Abolish {,ir}releven{ce,cy,t,tly}                     {}relevan{}
      Abolish rec{co,com,o}mend{,s,ed,ing,ation}            rec{om}mend{}
      Abolish reproducable                                  reproducible
      Abolish teh                                           the
    ]]
  end
}
