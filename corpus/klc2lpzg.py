
## Convert KLC tags into Leipzig tags.
## INPUT:
## >       Астана-арена<R_ZEQ><C5> Астана-аренада
## >       ел<R_ZE>        ел
## >       чемпион<R_ZE><N1><S3>   чемпиондары
## >       Шахтер<R_ZEQ>   Шахтер
## >       кубок<R_ZE>     кубок
## >       жеңімпаз<R_ZE><S3>      жеңімпазы
## >       Ордабасы<R_ZEQ><C7>     Ордабасымен
## ...
## OUTPUT:
## >       Астана-арена<NN><LOC> Астана-аренада
## >       ел<NN>        ел
## >       чемпион<NN><PL><POSS.3SP>   чемпиондары
## >       Шахтер<NNP>   Шахтер
## >       кубок<NN>     кубок
## >       жеңімпаз<NN><POSS.S3>      жеңімпазы
## >       Ордабасы<NNP><INSCOM>     Ордабасымен
## ..

import fileinput

KLC_2_LPZG = {
    "ABE": "ABE",  ## abessive
    "C2": "GEN",  ## genitive
    "C3": "DAT",  ## dative
    "C3SIM": "DAT",  ## dative
    "C4": "ACC",  ## accusative
    "C5": "LOC",  ## locative
    "C6": "ABL",  ## ablative
    "C7": "INSCOM",  ## instrumental/commitative
    "C7SIM": "INSCOM",  ## instrumental/commitative
    "CMP": "CMP",  ## comparative
    "EQU": "EQU",  ## equative
    "ETB_ESM": "PTCP",  ## participle
    "ETB_ETU": "GER",  ## gerund
    "ETB_KSE": "CVB",  ## converb
    "ETK_ESM": "PTCP",  ## participle
    "ETK_ETB": "NEG",  ## negation
    "ETK_ETU": "GER",  ## gerund
    "ETK_KSE": "CVB",  ## converb
    "ETPK_ESM": "PTCP",  ## participle
    "ETPK_ETB": "NEG",  ## negation
    "ETPK_ETU": "GER",  ## gerund
    "ETPK_KSE": "CVB",  ## converb
    "ETP_ESM": "PTCP",  ## participle
    "ETP_ETB": "NEG",  ## negation
    "ETP_ETU": "GER",  ## gerund
    "ETP_KSE": "CVB",  ## converb
    "ET_ESM": "PTCP",  ## participle
    "ET_ETB": "NEG",  ## negation
    "ET_ETU": "GER",  ## gerund
    "ET_KSE": "CVB",  ## converb
    "LATT": "LATT",  ## locative+attributive (-DAGI)
    "M2": "IMP",  ## imperative
    "M3": "DES",  ## desiderative
    "M4": "COND",  ## conditional
    "N1": "PL",  ## plural
    "N1S": "PL",  ## plural (N1S was used for the exceptional plural-after-possessive attachment (e.g. мамамдар = мама_R_ZE м_S1 дар_N1S = мама<NN><POSS.1Sg><PL>)
    "P1": "AGR.1SG",  ## agreement 1st singular
    "P2": "AGR.2SG",  ## agreement 2nd singular
    "P3": "AGR.3SP",  ## agreement 3rd singular/plural
    "P4": "AGR.2SGF",  ## agreement 2nd singular formal
    "P5": "AGR.1PL",  ## agreement 1st plural
    "P6": "AGR.2PL",  ## agreement 2nd plural
    "P7": "AGR.3SP",  ## agreement 3rd singular/plural
    "P8": "AGR.2PLF",  ## agreement 2nd plural formal
    "R_APS": "PUNCT",  ## punctuation
    "R_ATRN": "PUNCT",  ## punctuation
    "R_AZZ": "PUNCT",  ## punctuation
    "R_BOS": "FORGN",  ## foreign
    "R_BSLH": "PUNCT",  ## punctuation
    "R_DPH": "PUNCT",  ## punctuation
    "R_ELK": "VB",  ## verb
    "R_ET": "VB",  ## verb
    "R_ETB": "VBNEG",  ## analytic negation (jok/emes)
    "R_ETD": "VBE",  ## defunct -e verb
    "R_ETK": "AUX",  ## auxiliary verb
    "R_ETP": "VB",  ## verb
    "R_ETPK": "AUX",  ## auxiliary verb
    "R_LEP": "PUNCT",  ## punctuation
    "R_MOD": "PUNCT",  ## punctuation
    "R_NKT": "PUNCT",  ## punctuation
    "R_OS": "INTJ",  ## interjection
    "R_QNKT": "PUNCT",  ## punctuation
    "R_SE": "ADJ",  ## adjective
    "R_SH": "ADP",  ## adposition
    "R_SIM": "PRO",  ## pronoun
    "R_SLH": "PUNCT",  ## punctuation
    "R_SN": "NUM",  ## number
    "R_SUR": "PUNCT",  ## punctuation
    "R_SYM": "SYM",  ## symbol
    "R_TRN": "PUNCT",  ## punctuation
    "R_UNKT": "PUNCT",  ## punctuation
    "R_US": "ADV",  ## adverb
    "R_UTR": "PUNCT",  ## punctuation
    "R_X": "UNK",  ## unknown/unrecognized root
    "R_ZE": "NN",  ## noun, common
    "R_ZEQ": "NNP",  ## noun, proper
    "R_ZHL": "CNJ",  ## conjunction
    "R_ZTRN": "PUNCT",  ## punctuation
    "R_ZZZ": "PUNCT",  ## punctuation
    "S1": "POSS.1SG",  ## possessive 1st singular
    "S2": "POSS.2SG",  ## possessive 2nd singular
    "S3": "POSS.3SP",  ## possessive 3rd singular/plural
    "S3SIM": "POSS.3SP",  ## possessive 3rd singular/plural
    "S4": "POSS.2SPF",  ## possessive 2nd singular/plural
    "S5": "POSS.1SG",  ## possessive 1st plural
    "S9": "POSS",  ## possessive general (-Niki)
    "SML": "SML",  ## similative
    "T1": "AOR",  ## aorist tense
    "T2": "FUT",  ## future tense
    "T2NEG": "FUT",  ## future tense
    "T3": "PST",  ## past tense
    "T3E": "PST",  ## past tense (after defunct -e, as in baratyn et, instead of baratyn edi)
    "V1": "REFL",  ## reflexive voice
    "V2": "PASS",  ## passive voice
    "V3": "RECP",  ## reciprocal/cooperative voice
    "V4": "CAUS"  ## causative
}

for line in fileinput.input():
    line = line.rstrip()
    rest, lex, surf = line.split('\t')
    _ = lex.replace('<',
                    ' ').replace('>',
                                 ' ').replace('  ',
                                              ' ').rstrip().split(' ')
    lemma, tags = _[0], _[1:]
    print(rest, "".join([lemma] + \
                        ["<" + \
                         KLC_2_LPZG[tag] + \
                         ">" for tag in tags]),
          surf, sep = '\t')
