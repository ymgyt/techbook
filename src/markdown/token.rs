/// Token represents a markdown component elements.
pub enum Token {
    /// represents section #
    /// `## Title` => Sharp(2)
    Sharp(u8),

    /// plain content. delimited by new line.
    Line(String),

    /// code block quote.
    CodeQuote
}
