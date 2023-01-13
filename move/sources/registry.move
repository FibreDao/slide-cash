module reflow::registry {
    use std::vector;

    use sui::table::{Self, Table};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{TxContext};

    friend reflow::main;

    struct Registry has key {
        id: UID,
        all_streams: vector<ID>,
        incoming_streams: Table<address, vector<ID>>,
        outgoing_streams: Table<address, vector<ID>>,
    }

    public(friend) fun new(ctx: &mut TxContext): Registry {
        Registry {
            id: object::new(ctx),
            all_streams: vector::empty(),
            incoming_streams: table::new(ctx),
            outgoing_streams: table::new(ctx),
        }
    }

    public(friend) fun borrow_incoming_streams(self: &Registry): &Table<address, vector<ID>> {
        &self.incoming_streams
    }

    public(friend) fun borrow_ioutgoing_streams(self: &Registry): &Table<address, vector<ID>> {
        &self.incoming_streams
    }

    public(friend) fun borrow_iincoming_streams_mut(self: &mut Registry): &mut Table<address, vector<ID>> {
        &mut self.incoming_streams
    }

    public(friend) fun borrow_ioutgoing_streams_mut(self: &mut Registry): &mut Table<address, vector<ID>> {
        &mut self.incoming_streams
    }

    public(friend) fun register_stream(streams_table: &mut Table<address, vector<ID>>, address: address, stream_id: ID) {
        if(table::contains(streams_table, address)) {
            let streams = table::borrow_mut(streams_table, address);
            vector::push_back(streams, stream_id);
        } else {
            let streams = vector::empty<ID>();
            vector::push_back(&mut streams, stream_id);
            table::add(streams_table, address, streams);
        }
    }
}