require_relative 'json_to_gdx'

KS_GAMS_CODE = '
* knapsack.gms

set i objects;

parameters v(i) values
           w(i) weights;

scalar C maximum weight capacity of knapsack;

equations obj objective function
          cap capacity constraint;

variable Z objective value;
binary variable x(i) object i is taken;

obj .. Z =e= sum(i, v(i) * x(i));
cap .. sum(i, w(i) * x(i)) =l= C;

model knapsack /obj, cap/;

$if not set gdxincname $abort \'no include file name for data file provided\'
$GDXIN %gdxincname%.gdx
$LOAD i, v, w, C
$GDXIN

solve knapsack maximizing Z using MIP;
'.freeze

KS_DATA_OBJ = {
    sets: [{ name: 'i', from: 1, to: 4 }],
    parameters: [
        { name: 'v', indices: 'i', values: [1, 2, 3, 4] },
        { name: 'w', indices: 'i', values: [1, 2, 3, 4] }
    ],
    scalars: [{ name: 'C', value: 4 }]
}.freeze

RCPSP_ROC_GAMS_CODE = '
sets j Arbeitsgänge
     t Perioden
     r Ressourcen;

alias(j,i);
alias(t,tau);

sets pred(i,j) yes gdw. i Vorgänger von j ist
     tw(j, t) yes gdw. t im Zeitfenster von j liegt
     actual(j) yes gdw. Job kein Dummy
     lastJob(j) yes gdw. Job letzter AG
     fw(j, t, tau) yes gdw. AG j in tau beendet werden kann wenn er in t lief;

parameters
         seedsol(j)      Startloesung
         solvetime       CPU-Zeit
         slvstat         Termination status
         modelstat       Model solution status
         zmax(r)         Maximale ZK
         kappa(r)        Kosten pro Einheit ZK
         capacities(r)   Kapazitäten
         durations(j)    Dauern
         u(t)            Erlös (Parabel) bei Makespan t
         efts(j)         Früheste Startzeitpunkte
         lfts(j)         Späteste Endzeitpunkte
         demands(j,r)    Bedarf;

binary variable  x(j,t) 1 gdw. AG j in Periode t endet d.h. FTj=t;
variables        z(r,t) Einheiten ZK von r in Periode t gebucht
                 profit Gewinn (Parabel);

equations
                objective   Weitere ZF
                precedence  Vorrangbeziehung durchsetzen
                resusage    Ressourcenverbrauchsrestriktion
                once        Jeden AG genau 1x einplanen
                oclimits    Beschränke buchbare ZK;

objective                 .. profit =e= sum(j$lastJob(j), sum(t$tw(j,t), x(j,t)*u(t)))-sum(r, sum(t, z(r,t)*kappa(r)));
precedence(i,j)$pred(i,j) .. sum(t$tw(i,t), (ord(t)-1)*x(i,t)) =l= sum(t$tw(j,t), (ord(t)-1)*x(j,t)) - durations(j);
resusage(r,t)             .. sum(j$actual(j), demands(j,r)*sum(tau$fw(j,t,tau), x(j,tau))) =l= capacities(r) + z(r,t);
once(j)                   .. sum(t$tw(j,t), x(j,t)) =e= 1;
oclimits(r,t)             .. z(r,t) =l= zmax(r);

model rcpspoc  /objective, precedence, resusage, once/;

$GDXIN %gdxincname%.gdx
$load j t r zmax kappa capacities durations u demands pred
$GDXIN

efts(j) = 0;
lfts(j) = card(t);

tw(j, t)$(efts(j) <= (ord(t)-1) and (ord(t)-1) <= lfts(j)) = yes;
actual(j)$(1 < ord(j) and ord(j) < card(j)) = yes;
lastJob(j)$(ord(j) = card(j)) = yes;
fw(j, t, tau)$(ord(tau)>=ord(t) and ord(tau)<=ord(t)+durations(j)-1 and tw(j,tau)) = yes;
z.lo(r,t) = 0;
z.up(r,t) = zmax(r);
profit.lo = 0;

solve rcpspoc using mip maximizing profit;
'.freeze
RCPSP_ROC_DATA_OBJ = {
    "sets": [
        { "name": "j", "from": 1, "to": 12 },
        { "name": "r", "from": 1, "to": 1 },
        { "name": "t", "from": 0, "to": 18 },
        { "name": "pred", "indices": ["j", "j"], "values": [
            ["j1", "j2"],
            ["j1", "j6"],
            ["j2", "j3"],
            ["j3","j4"],
            ["j3","j8"],
            ["j4","j5"],
            ["j5","j10"],
            ["j6","j7"],
            ["j7","j4"],
            ["j7","j8"],
            ["j8","j9"],
            ["j9","j10"],
            ["j9","j11"],
            ["j10","j12"],
            ["j11","j12"]]}
    ],
    "parameters": [
        {"name": "zmax", "indices": "r", "values": [1] },
        {"name": "kappa", "indices": "r", "values": [0.5] },
        {"name": "capacities", "indices": "r", "values": [3] },
        {"name": "durations", "indices": "j", "values": [0, 2, 1, 2, 3, 2, 1, 2, 2, 1, 2, 0]},
        {"name": "u", "indices": "t", "values": [6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.36, 5.97, 5.3, 4.3, 3.1, 1.7]},
        {"name": "demands", "indices": ["j", "r"], "values": [[0, 3, 3, 3, 2, 2, 2, 1, 1, 1, 0]]}
    ],
    "scalars": [
        {"name": "deadline", "value": -1}
    ]
}.freeze

module Examples
  def self.knapsack
    res = JsonToGdx.solve_model_with_data_obj(KS_GAMS_CODE, KS_DATA_OBJ)
    puts res
  end

  def self.rcpsp_roc
    res = JsonToGdx.solve_model_with_data_obj(RCPSP_ROC_GAMS_CODE, RCPSP_ROC_DATA_OBJ)
    puts res
  end
end