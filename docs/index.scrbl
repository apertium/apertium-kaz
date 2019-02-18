#lang scribble/manual

@title{@code{APERTIUM-KAZ}: A MORPHOLOGICAL TRANSDUCER AND DISAMBIGUATOR FOR
 KAZAKH}

@margin-note{WARNING: this is an early draft.}

What follows is the documentation for @code{apertium-kaz} -- a morphological
transducer and disambiguator for Kazakh. First draft of this documentation was
written, or, rather, assembled from various writings on @(link
"https://wiki.apertium.org" "Apertium's wiki") and then extended with more
details by @(link "http://github.com/IlnarSelimcan" "ifs") on September-October
2018 for members of the `Deep Learning for Sequential Models in Natural
Language Processing with Applications to Kazakh' (@italic{dlsmnlpak}) research
group at Nazarbayev University and elsewhere. That being said, I hope that it
will be useful for anyone who uses @code{apertium-kaz} and maybe wants or needs to
extend it with more stems or other features. Most of the things said in this
guide should be applicable to Apertium's transducers for other Turkic languages
as well.
