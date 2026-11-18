/* BAI31123 Knowledge Representation - Network Troubleshooting Expert System
   Two-member project (Abbie Song, Goh Tse Thing).
   Abbie Song: Wi-Fi / IP / DNS knowledge (it_is/1 middle layer and the
               Wi-Fi Disabled, Weak Wi-Fi Signal, IP Configuration Problem
               and DNS Problem outcomes).
   Goh Tse Thing: interaction, answer memory, explanations, unknown handling,
               and the router / ISP / cable diagnosis rules.
   Run: swipl -q -s network_expert_system.pl -g start
   Input: yes / no / unknown (lowercase only).
   A terminating dot is required when using the standard Prolog terminal.
   End-of-file is treated as unknown.
*/
:- dynamic known/2.

% --- Layer 1: question interface and fact memory ---
question(connection_type, 'Are you using a wired (Ethernet) connection?').
question(wifi_enabled, 'Is Wi-Fi enabled on your device?').
question(network_detected, 'Can your device detect the Wi-Fi network?').
question(wifi_signal_weak, 'Is the Wi-Fi signal weak or unstable?').
question(connected, 'Does your device show that it is connected to the network?').
question(internet_access, 'Can you access the internet normally?').
question(other_devices_connect, 'Can other devices access the internet using the same router?').
question(router_lights_normal, 'Are the router internet/status lights normal?').
question(router_restart_fixes, 'Does restarting the router restore internet access?').
question(isp_outage_reported, 'Has your ISP reported an outage in your area?').
question(cable_secure, 'Is the Ethernet/WAN cable firmly connected at both ends?').
question(link_light_on, 'Is the Ethernet link indicator light on?').
question(ip_address_valid, 'Does the device have a valid IP address (not 169.254.x.x)?').
question(ip_website_access, 'Can you open a website by its numeric IP address?').

% Retrieve the stored answer first, then compare it with the rule's expected
% value. This avoids asking again when a rule expects a different response.
answer(Key, Value) :-
    known(Key, Stored), !,
    Value = Stored.
answer(Key, Value) :-
    question(Key, Prompt),
    format('~w (yes/no/unknown): ', [Prompt]),
    read_input(Stored),
    assertz(known(Key, Stored)),
    Value = Stored.

read_input(Value) :-
    catch(read(Term), _, Term = invalid),
    ( Term == end_of_file ->
        Value = unknown
    ; atom(Term), memberchk(Term, [yes, no, unknown]) ->
        Value = Term
    ; writeln('Please enter lowercase yes, no, or unknown.'),
      read_input(Value)
    ).

verify(Key, Value) :- answer(Key, Value).
yes(Key) :- verify(Key, yes).
no(Key) :- verify(Key, no).

% --- Layer 2a: connection type (wired or wireless) ---
connection(wired) :- yes(connection_type).
connection(wireless) :- no(connection_type).

% --- Layer 2b: Wi-Fi / IP / DNS middle layer (it_is/1, as in Lab 5) ---
it_is(wifi_inactive) :-
    connection(wireless), verify(wifi_enabled, no).
it_is(wireless_available) :-
    connection(wireless), verify(wifi_enabled, yes),
    verify(network_detected, yes).
it_is(unstable_wireless) :-
    it_is(wireless_available), verify(wifi_signal_weak, yes).
it_is(network_connected) :-
    connection(wired), verify(connected, yes).
it_is(network_connected) :-
    it_is(wireless_available), verify(connected, yes).
it_is(invalid_ip_configuration) :-
    it_is(internet_failure), verify(ip_address_valid, no).
it_is(internet_failure) :-
    it_is(network_connected), verify(internet_access, no).
it_is(domain_resolution_failure) :-
    it_is(internet_failure), verify(ip_address_valid, yes),
    verify(ip_website_access, yes).

% --- Layer 2c: shared-outage and cable conditions ---
shared_outage :- no(internet_access),
                no(other_devices_connect).
router_suspect :- shared_outage, no(router_lights_normal).
router_suspect :- shared_outage, yes(router_restart_fixes).
isp_suspect :- shared_outage, yes(router_lights_normal),
               no(router_restart_fixes), yes(isp_outage_reported).
cable_suspect :- connection(wired), no(cable_secure).
cable_suspect :- connection(wired), yes(cable_secure), no(link_light_on).

% --- Layer 3: conclusions (ordered; first matching diagnosis wins) ---
% The rule order is deliberate: obvious local faults first, shared problems next.
diagnosis(wifi_disabled, 'Wi-Fi is switched off on this device.') :-
    it_is(wifi_inactive), !.
diagnosis(cable_connection_problem, 'The physical cable or Ethernet link may be faulty.') :-
    cable_suspect, !.
diagnosis(weak_wifi_signal, 'The reported wireless signal is weak or unstable.') :-
    it_is(unstable_wireless), !.
diagnosis(ip_configuration_problem, 'The device may not have a valid IP configuration.') :-
    it_is(invalid_ip_configuration), !.
diagnosis(dns_problem, 'IP addresses work, but normal website names may not resolve.') :-
    it_is(domain_resolution_failure), !.
diagnosis(router_problem, 'Several devices are affected, and router evidence suggests a local fault.') :-
    router_suspect, !.
diagnosis(isp_outage, 'Several devices are affected and ISP outage evidence was reported.') :-
    isp_suspect, !.
diagnosis(unknown_network_problem, 'No diagnostic rule matches the supplied evidence.').

% --- Layer 4: user-facing explanations and next actions ---
label(wifi_disabled, 'Wi-Fi Disabled').
label(cable_connection_problem, 'Cable Connection Problem').
label(weak_wifi_signal, 'Weak Wi-Fi Signal').
label(ip_configuration_problem, 'IP Configuration Problem').
label(dns_problem, 'DNS Problem').
label(router_problem, 'Router Problem').
label(isp_outage, 'ISP Outage').
label(unknown_network_problem, 'Unknown Network Problem').

advice(wifi_disabled, 'Enable Wi-Fi and reconnect to the network.').
advice(cable_connection_problem, 'Reseat both cable ends; test another cable or Ethernet port.').
advice(weak_wifi_signal, 'Move nearer the router and check for wireless interference.').
advice(ip_configuration_problem, 'Check DHCP/IP settings and renew the device IP address.').
advice(dns_problem, 'Check DNS settings or try another trusted DNS resolver.').
advice(router_problem, 'Check router indicators, cables and settings; restart if safe.').
advice(isp_outage, 'Check the ISP status page or contact the ISP for assistance.').
advice(unknown_network_problem,
       'Check settings and cables, record the symptoms, or contact your ISP/support.').

start :-
    retractall(known(_, _)),
    writeln('=== Network Troubleshooting Expert System ==='),
    writeln('Reply with yes, no, or unknown (lowercase only).'),
    diagnosis(Diagnosis, Reason),
    label(Diagnosis, Name),
    advice(Diagnosis, Advice),
    format('~nDiagnosis: ~w~nReason: ~w~nSuggested action: ~w~n',
           [Name, Reason, Advice]),
    ( Diagnosis == unknown_network_problem -> summarize_answers ; true ),
    writeln('Type why. to see the evidence, or exit. to finish:'),
    read_explanation_choice(Reason).

read_explanation_choice(Reason) :-
    catch(read(Choice), _, Choice = exit),
    ( Choice == why ->
        format('~nWhy: ~w~n', [Reason]),
        summarize_answers
    ; Choice == exit -> true
    ; Choice == end_of_file -> true
    ; writeln('Please type why. or exit.'), read_explanation_choice(Reason)
    ).

summarize_answers :-
    writeln('Answers used during this diagnosis:'),
    ( known(_, _) ->
        forall(known(Key, Value),
               (question(Key, Prompt), format('  - ~w => ~w~n', [Prompt, Value])))
    ; writeln('  (no answers were available)') ).

% Each call to start/0 clears previously remembered answers.
% Test harnesses may also seed known/2 directly.
