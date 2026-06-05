// CPU-bound parallelism with rayon
use rayon::prelude::*;
let sum: u64 = data.par_iter().map(|x| x * x).sum();

// Fan-out with JoinSet
let mut set = tokio::task::JoinSet::new();
for item in items {
    set.spawn(async move { process(item).await });
}
while let Some(result) = set.join_next().await {
    handle(result?)?;
}

// Bounded channel for backpressure
let (tx, rx) = tokio::sync::mpsc::channel(32);
