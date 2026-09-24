const eventDetails = {
  ia: {
    title: 'IA útil, no humo.',
    copy: 'Una conversación práctica para separar las promesas vacías de las herramientas que ya pueden mejorar nuestro trabajo. Trae una pregunta real y sal con un experimento concreto.'
  },
  datos: {
    title: 'Diseñar con datos.',
    copy: 'Un taller online para transformar métricas en decisiones de producto. Trabajaremos con ejemplos sencillos y una plantilla que podrás reutilizar en tu próximo proyecto.'
  },
  hack: {
    title: 'Hack the ordinary.',
    copy: 'Una mañana para prototipar ideas que hagan las cosas cotidianas un poco más inteligentes. Equipos pequeños, materiales simples y tiempo para probar sin miedo.'
  }
};

const filters = document.querySelectorAll('[data-filter]');
const events = document.querySelectorAll('.event');
const searchInput = document.querySelector('#event-search');
const emptyState = document.querySelector('.empty-state');

function filterEvents() {
  const activeFilter = document.querySelector('.filter.is-active')?.dataset.filter || 'all';
  const query = searchInput.value.trim().toLowerCase();
  let visibleCount = 0;

  events.forEach((event) => {
    const matchesFilter = activeFilter === 'all' || event.dataset.category.includes(activeFilter);
    const matchesSearch = !query || event.dataset.title.toLowerCase().includes(query);
    const isVisible = matchesFilter && matchesSearch;
    event.classList.toggle('is-hidden', !isVisible);
    if (isVisible) visibleCount += 1;
  });

  emptyState.hidden = visibleCount !== 0;
}

filters.forEach((filter) => {
  filter.addEventListener('click', () => {
    filters.forEach((item) => item.classList.remove('is-active'));
    filter.classList.add('is-active');
    filterEvents();
  });
});

searchInput.addEventListener('input', filterEvents);

const modal = document.querySelector('#event-modal');
const modalTitle = document.querySelector('#modal-title');
const modalCopy = document.querySelector('#modal-copy');

function closeModal() {
  modal.hidden = true;
  document.body.style.overflow = '';
}

document.querySelectorAll('[data-event]').forEach((button) => {
  button.addEventListener('click', () => {
    const detail = eventDetails[button.dataset.event];
    modalTitle.textContent = detail.title;
    modalCopy.textContent = detail.copy;
    modal.hidden = false;
    document.body.style.overflow = 'hidden';
  });
});

document.querySelectorAll('[data-close-modal]').forEach((element) => element.addEventListener('click', closeModal));
document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && !modal.hidden) closeModal();
});

document.querySelector('#join-form').addEventListener('submit', (event) => {
  event.preventDefault();
  const message = document.querySelector('.form-message');
  message.textContent = 'Perfecto. Te avisaremos del próximo encuentro.';
  event.target.reset();
});
