% Knowledge Base (Questions)
question(wifi_enabled,
    'Is Wi-Fi enabled on your device?').

question(network_detected,
    'Can your device detect the Wi-Fi network?').

question(weak_signal,
    'Is the Wi-Fi signal weak or unstable?').

question(wifi_connected,
    'Is your device connected to the Wi-Fi network?').

question(valid_ip,
    'Does your device have a valid IP configuration?').

question(internet_access,
    'Can your device access the internet normally?').

question(ip_access,
    'Can you access websites using their IP addresses?').


% Middle-Layer Rules
% Rule 1: Wi-Fi is inactive
it_is(wifi_inactive) :-
    verify(wifi_enabled, no).

% Rule 2: Wireless network is available
it_is(wireless_available) :-
    verify(wifi_enabled, yes),
    verify(network_detected, yes).

% Rule 3: Wireless signal is unstable
it_is(unstable_wireless) :-
    it_is(wireless_available),
    verify(weak_signal, yes).

% Rule 4: Device is connected to Wi-Fi
it_is(network_connected) :-
    it_is(wireless_available),
    verify(wifi_connected, yes).

% Rule 5: Invalid IP configuration
it_is(invalid_ip_configuration) :-
    it_is(network_connected),
    verify(valid_ip, no).

% Rule 6: Internet access failure
it_is(internet_failure) :-
    it_is(network_connected),
    verify(internet_access, no).

% Rule 7: Domain name resolution failure
it_is(domain_resolution_failure) :-
    it_is(internet_failure),
    verify(valid_ip, yes),
    verify(ip_access, yes).


% Diagnosis Rules
% Rule 8: Wi-Fi Disabled
diagnosis(wifi_disabled) :-
    it_is(wifi_inactive).

% Rule 9: Weak Wi-Fi Signal
diagnosis(weak_wifi_signal) :-
    it_is(unstable_wireless).

% Rule 10: IP Configuration Problem
diagnosis(ip_configuration_problem) :-
    it_is(invalid_ip_configuration).

% Rule 11: DNS Problem
diagnosis(dns_problem) :-
    it_is(domain_resolution_failure).
