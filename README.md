# wumpus

# 🧌 The Wumpus: Agentic AI / Decision Making

Bayesian Inference and Constraint Satisfaction Programming to guide a free agent using perceptions to search a grid space and perform a task while calculating probabilities of dangers en route
- wumpus.ipynb
- knowledge_base.perl
- game_state.json
The code from the Prolog file `knowledge_base.perl` and the updating `game_state.json` are also included in `wumpus.ipynb` cell blocks.

---  
---  

## **Overview**:  
The Wumpus World is a foundational problem in artificial intelligence where an agent navigates a cave-like grid to locate treasure while avoiding the lethal Wumpus and dangerous pits. The agent relies on sparse sensory inputs: a breeze indicates a pit nearby, while a stench warns of the Wumpus's proximity.  

## **Approach**:  
### 2.1 Integration of Prolog for Logical Reasoning  
In our implementation, Prolog manages the logical reasoning aspects necessary for simulating the environment of the Wumpus World. The provided Prolog code focuses on reading and writing to a JSON file representing the game state, handling updates based on in-game logic, and managing percept updates. Specifically:  
- The `update_percepts/0` predicate orchestrates the overall update process by reading the current game state, processing updates, and then writing back the modified state.
-	`update_all_percepts/2` and `update_cell_percepts/3` are used for updating percepts in all cells based on adjacent features and current cell characteristics, such as the presence of a Wumpus, pits, or gold.
-	Predicates like `update_stenchy/3`, `update_windy/3`, and `update_glitter/2` specifically modify cell percepts based on the proximity of dangers or the presence of gold.
-	The `is_adjacent/2` and `cell_has_feature/2` predicates determine adjacency and feature presence, which is crucial for deriving safe and risky paths through logical inference.  
This Prolog implementation facilitates a dynamic knowledge base where logical deductions are made based on predefined and evolving environmental conditions.  

### 2.2 Python Implementation for Probabilistic Analysis  
On the Python side, the system computes probabilities and manages interactions with the Prolog component to maintain an updated and accurate model of the game state:  
-	The `initialize_game_state` function sets initial probabilities excluding the starting cell, reflecting an unbiased starting point for exploration.
-	`update_game_state_from_prolog` functions as an intermediary that integrates Prolog's logical output into the Python-managed JSON state, ensuring that percept updates from Prolog are reflected in the probabilistic model.
-	`calculate_joint_probabilities` dynamically updates the likelihood of encountering hazards using Bayesian inference based on new percepts, adjusting the agent's knowledge about the safety of each cell. This method recalculates probabilities using information about adjacent cells, providing a more accurate risk assessment before the agent moves.  
This setup effectively combines Prolog’s strength in deductive reasoning with Python’s capabilities in handling probabilistic calculations and data management. The dual approach allows for nuanced decision-making in a complex, dynamic environment.  

## **Application of Bayesian Inference in Python**  
In this project, Bayesian inference is pivotal in updating the agent's beliefs about the environment based on new sensory information. Bayesian inference is a method of statistical inference in which Bayes' theorem is used to update the probability of a hypothesis as more evidence or information becomes available.  

### 3.1 Mathematical Foundation of Bayesian Inference  
Bayes' Theorem is mathematically expressed as:  
$P(H ∣ E) = P(E ∣ H) × P(H) P(E) → P(H ∣ E) = P(E) P(E ∣ H) × P(H)$
where:  
-	$P(H ∣ E)$ is the probability of the hypothesis $H$ given the evidence $E$.
-	$P(E ∣ H)$ is the probability of observing the evidence $E$ given that $H$ is true.
-	$P(H)$ is the initial probability of the hypothesis before seeing the evidence.
-	$P(E)$ is the total probability of observing the evidence under all possible hypotheses.  
In the context of the Wumpus World:  
-	Hypothesis $H$: Represents scenarios such as the presence of a Wumpus or a pit in a specific cell.
-	Evidence $E$: This comprises sensory percepts from adjacent cells, such as 'stenchy' or 'windy' indications.  

### 3.2 Implementing Bayesian Updating  
In the `calculate_joint_probabilities` function, Bayesian updating is performed to refine the probabilities of encountering a Wumpus or falling into a pit in each cell. The function calculates:  
-	$P(stench ∣ wumpus)$ and $P(breeze ∣ pit)$, which are the probabilities of sensing a stench if a Wumpus is present and sensing a breeze if a pit is present, respectively. These probabilities are derived from the game's rules and the nature of the environment.  
-	The complement probabilities $P(¬stench ∣ wumpus)$ and $P(¬breeze ∣ pit)$ are crucial for scenarios where no percepts are detected but the threat may still be present.  
The Bayesian updates adjust the probability of each hypothesis (Wumpus, pit) based on the presence or absence of respective percepts in adjacent cells. This results in a dynamic and continually evolving model of environmental risks as the agent explores more of the Wumpus World.  

### 3.3 Practical Impact of Bayesian Inference  
The practical application of these calculations allows the agent to make informed decisions about safe pathways. For example, the recalculated probabilities help determine whether exploring new cells is safer or avoiding risky areas potentially harboring hidden dangers. The agent uses this probabilistic logic to navigate efficiently, seeking the treasure while minimizing the risks of deadly encounters.  

## **Results**
In operation, our implementation demonstrates a high degree of adaptability and precision. For instance, when the Prolog side updates the percepts indicating a high likelihood of a Wumpus in an adjacent cell, the Python side recalculates the safety probabilities, often significantly reducing the safety score of nearby cells and thus guiding the agent away from potential threats. Sample output might show that after detecting a stench in two adjacent cells, the probability of a Wumpus being present in neighboring cells could jump, leading to strategic avoidance by the agent.

## **Future Considerations**
Integrating logical reasoning in Prolog with probabilistic calculations in Python proves highly effective for navigating the Wumpus World. The methodology allows for sophisticated interaction between symbolic logic and numerical analysis, enhancing the agent's ability to make informed decisions. Future improvements could focus on enhancing the efficiency of the Prolog queries and further refining the Bayesian updating mechanism in Python to speed up decision-making processes and handle larger or more complex environments. Additionally, integrating machine learning techniques could provide the agent with predictive capabilities, improving its performance in unknown territories based on past experiences.

