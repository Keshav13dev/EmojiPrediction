module Voting::VotingContract {
    
    // Struct to hold a proposal and its votes
    struct Proposal has key {
        description: vector<u8>,    
        votes_for: u64,             
        votes_against: u64          
    }

    // Create a proposal
    public fun create_proposal(account: &signer, description: vector<u8>) {
        let proposal = Proposal {
            description,
            votes_for: 0,
            votes_against: 0,
        };
        let address = signer::address_of(account);
        move_to(account, proposal);
    }

    // Cast a vote
    public fun vote(account: &signer, in_favor: bool) acquires Proposal {
        let address = signer::address_of(account);
        let proposal = borrow_global_mut<Proposal>(address);
        if (in_favor) {
            proposal.votes_for = proposal.votes_for + 1;
        } else {
            proposal.votes_against = proposal.votes_against + 1;
        }
    }

    // Get results of the proposal
    public fun get_results(account: &signer): (vector<u8>, u64, u64) acquires Proposal {
        let address = signer::address_of(account);
        let proposal = borrow_global<Proposal>(address);
        (proposal.description, proposal.votes_for, proposal.votes_against)
    }
}
