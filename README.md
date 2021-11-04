# Automating Azure Admin Consent Grants
__Prerequisites:__
If You do want to restrict access to what can be granted and who can perform grants, Premium licensed Azure AD is needed.
Consent Policies are part of Premium license offering (per 11/2021).

# Background
When managing Authorization using CI/CD, Your automats need to be able to read data from Azure AD. Nowadays that is done using MS Graph API. Of course there can be variation in how corporations want to manage _Read_ not to mention _Read/Write_ access to Azure AD, but I have recently been working in an environment, where _Read_ access was not automatically granted to fetch full list of users or groups. This of course applies to _Application_ level permissions and not to the case where your own credentials are used to get your data or some other data you have been granted access to (_Delegated_ permissions).

It is fairly hard to perform Azure Infra authorization without having the access to read at least _Groups_. 

Automating Admin Consent Grant in Azure AD streamlines Cloud Onboarding
