vcl 4.0;

backend default {
    .host = "web";
    .port = "3000";
}

sub vcl_recv {
    if (req.url ~ "^/assets/" || req.url ~ "^/public/") {
        return (hash);
    }
    return (pass);
}

sub vcl_backend_response {
    if (bereq.url ~ "^/assets/" || bereq.url ~ "^/public/") {
        set beresp.ttl = 1h;
    }
}